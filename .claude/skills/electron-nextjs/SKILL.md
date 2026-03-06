---
name: electron-nextjs
description: Adds Electron to an existing Next.js project, enabling desktop app functionality with native features like file dialogs, system tray, and IPC communication.
---

# Electron + Next.js Integration Skill

This skill guides you through adding Electron to an existing Next.js project, creating a desktop application that runs your Next.js app in a native window with access to system APIs.

## When to Use

Invoke with `/electron-nextjs` when you want to:
- Convert an existing Next.js web app into a desktop application
- Add native features like file dialogs, system tray, or notifications
- Enable offline functionality or local file system access

## Overview

The integration follows this architecture:
- **Development**: Electron loads `http://localhost:3000` (Next.js dev server)
- **Production**: Electron loads the built Next.js app or a static HTML file
- **IPC Communication**: Secure bridge between React components and Node.js APIs

## Step 1: Install Dependencies

```bash
npm install --save-dev electron
```

## Step 2: Create Electron Directory Structure

Create the `electron/` directory at project root with these files:

```
electron/
  main.js      # Main process - creates windows, handles IPC
  preload.js   # Preload script - exposes APIs to renderer
  index.html   # Fallback for production (optional)
```

## Step 3: Create main.js

Create `electron/main.js`:

```javascript
const { app, BrowserWindow, ipcMain, dialog } = require('electron')
const path = require('node:path')

const createWindow = () => {
  const isDev = process.env.NODE_ENV === 'development'

  const mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    show: false, // Don't show until ready
    backgroundColor: '#1a1a1a', // Match app background to prevent white flash
    webPreferences: {
      preload: path.join(__dirname, 'preload.js')
    }
  })

  // Show window only when content is ready (prevents white flash)
  mainWindow.once('ready-to-show', () => {
    mainWindow.show()
  })

  // Register DevTools shortcut (F12 or Ctrl+Shift+I)
  mainWindow.webContents.on('before-input-event', (event, input) => {
    if (input.key === 'F12' ||
        (input.control && input.shift && input.key.toLowerCase() === 'i')) {
      mainWindow.webContents.toggleDevTools()
    }
  })

  // In development, load the Next.js dev server
  // In production, load the built app
  if (isDev) {
    mainWindow.loadURL('http://localhost:3000')
  } else {
    // Option 1: Load a static fallback
    mainWindow.loadFile(path.join(__dirname, 'index.html'))
    // Option 2: For full Next.js production, use electron-serve or similar
  }
}

// Initialize app
app.whenReady().then(() => {
  createWindow()

  // macOS: Re-create window when dock icon clicked
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

// Quit when all windows closed (except macOS)
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
})

// ============================================
// IPC Handlers - Add your native functionality here
// ============================================

// Example: Native folder selection dialog
ipcMain.handle('select-directory', async () => {
  const result = await dialog.showOpenDialog({
    properties: ['openDirectory'],
    title: 'Select Directory'
  })

  if (result.canceled || result.filePaths.length === 0) {
    return null
  }

  return result.filePaths[0]
})

// Example: Native file selection dialog
ipcMain.handle('select-file', async (event, options) => {
  const result = await dialog.showOpenDialog({
    properties: ['openFile'],
    filters: options?.filters || [],
    title: options?.title || 'Select File'
  })

  if (result.canceled || result.filePaths.length === 0) {
    return null
  }

  return result.filePaths[0]
})

// Example: Save file dialog
ipcMain.handle('save-file', async (event, options) => {
  const result = await dialog.showSaveDialog({
    filters: options?.filters || [],
    defaultPath: options?.defaultPath,
    title: options?.title || 'Save File'
  })

  if (result.canceled) {
    return null
  }

  return result.filePath
})
```

## Step 4: Create preload.js

Create `electron/preload.js`:

```javascript
// Preload script runs before the renderer process loads
// It has access to both DOM APIs and Node.js environment
const { contextBridge, ipcRenderer } = require('electron')

// Expose Electron APIs to the renderer process securely
contextBridge.exposeInMainWorld('electronAPI', {
  // Directory selection
  selectDirectory: () => ipcRenderer.invoke('select-directory'),

  // File selection
  selectFile: (options) => ipcRenderer.invoke('select-file', options),

  // Save file dialog
  saveFile: (options) => ipcRenderer.invoke('save-file', options),

  // Add more APIs as needed:
  // showNotification: (title, body) => ipcRenderer.invoke('show-notification', { title, body }),
  // readFile: (path) => ipcRenderer.invoke('read-file', path),
  // writeFile: (path, content) => ipcRenderer.invoke('write-file', path, content),
})

// Optional: Display version info on DOMContentLoaded
window.addEventListener('DOMContentLoaded', () => {
  const replaceText = (selector, text) => {
    const element = document.getElementById(selector)
    if (element) element.innerText = text
  }

  for (const dependency of ['chrome', 'node', 'electron']) {
    replaceText(`${dependency}-version`, process.versions[dependency])
  }
})
```

## Step 5: Create TypeScript Types and Utilities

Create `lib/electron.ts` for type-safe Electron API access from React:

```typescript
// Electron detection and IPC utilities

interface ElectronAPI {
  selectDirectory: () => Promise<string | null>;
  selectFile: (options?: {
    filters?: { name: string; extensions: string[] }[];
    title?: string;
  }) => Promise<string | null>;
  saveFile: (options?: {
    filters?: { name: string; extensions: string[] }[];
    defaultPath?: string;
    title?: string;
  }) => Promise<string | null>;
}

declare global {
  interface Window {
    electronAPI?: ElectronAPI;
  }
}

/**
 * Check if running in Electron environment
 */
export function isElectron(): boolean {
  return typeof window !== 'undefined' &&
         typeof window.electronAPI !== 'undefined';
}

/**
 * Open native directory selection dialog
 * Returns null if not in Electron or user cancels
 */
export async function selectDirectory(): Promise<string | null> {
  if (!isElectron()) return null;
  return window.electronAPI!.selectDirectory();
}

/**
 * Open native file selection dialog
 * Returns null if not in Electron or user cancels
 */
export async function selectFile(options?: {
  filters?: { name: string; extensions: string[] }[];
  title?: string;
}): Promise<string | null> {
  if (!isElectron()) return null;
  return window.electronAPI!.selectFile(options);
}

/**
 * Open native save file dialog
 * Returns null if not in Electron or user cancels
 */
export async function saveFile(options?: {
  filters?: { name: string; extensions: string[] }[];
  defaultPath?: string;
  title?: string;
}): Promise<string | null> {
  if (!isElectron()) return null;
  return window.electronAPI!.saveFile(options);
}
```

## Step 6: Update package.json

Add the `main` entry and Electron scripts:

```json
{
  "main": "electron/main.js",
  "scripts": {
    "electron": "electron .",
    "electron:dev": "set NODE_ENV=development&& electron ."
  }
}
```

**Note for macOS/Linux**, use:
```json
"electron:dev": "NODE_ENV=development electron ."
```

## Step 7: Using Electron Features in React Components

Example: Directory picker with fallback for web:

```tsx
'use client';

import { useState } from 'react';
import { isElectron, selectDirectory } from '@/lib/electron';

export default function DirectoryPicker({
  value,
  onChange
}: {
  value: string;
  onChange: (path: string) => void;
}) {
  const [error, setError] = useState<string | null>(null);
  const inElectron = isElectron();

  const handleBrowse = async () => {
    const selected = await selectDirectory();
    if (selected) {
      onChange(selected);
      setError(null);
    }
  };

  return (
    <div className="input-group">
      <input
        type="text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder="/path/to/directory"
      />

      {/* Only show Browse button in Electron */}
      {inElectron && (
        <button onClick={handleBrowse} type="button">
          Browse
        </button>
      )}

      {error && <p className="error">{error}</p>}
    </div>
  );
}
```

## Step 8: Running the App

**Development mode** (requires two terminals):

```bash
# Terminal 1: Start Next.js dev server
npm run dev

# Terminal 2: Start Electron (after Next.js is running)
npm run electron:dev
```

**Or use concurrently** for single command:

```bash
npm install --save-dev concurrently wait-on
```

Add to package.json:
```json
"scripts": {
  "electron:start": "concurrently \"npm run dev\" \"wait-on http://localhost:3000 && npm run electron:dev\""
}
```

## Common IPC Patterns

### Adding a New IPC Handler

1. **In `electron/main.js`**, add the handler:
```javascript
ipcMain.handle('my-action', async (event, arg1, arg2) => {
  // Perform native operation
  return result;
})
```

2. **In `electron/preload.js`**, expose it:
```javascript
contextBridge.exposeInMainWorld('electronAPI', {
  // ... existing APIs
  myAction: (arg1, arg2) => ipcRenderer.invoke('my-action', arg1, arg2),
})
```

3. **In `lib/electron.ts`**, add the type and wrapper:
```typescript
interface ElectronAPI {
  // ... existing types
  myAction: (arg1: string, arg2: number) => Promise<ResultType>;
}

export async function myAction(arg1: string, arg2: number): Promise<ResultType | null> {
  if (!isElectron()) return null;
  return window.electronAPI!.myAction(arg1, arg2);
}
```

## Best Practices

### Security
- Never disable `nodeIntegration` or `contextIsolation` security defaults
- Always use `contextBridge` to expose specific APIs, not all of Node.js
- Validate all IPC inputs in main process handlers

### UX
- Use `show: false` + `ready-to-show` to prevent white flash on startup
- Match `backgroundColor` to your app's background color
- Provide graceful fallbacks for web-only mode

### Architecture
- Keep native code in `electron/` directory
- Use `lib/electron.ts` as the single interface for React components
- Always check `isElectron()` before calling native APIs

## Production Build

For production builds, consider:

1. **electron-builder** or **electron-forge** for packaging
2. **electron-serve** to serve the Next.js output
3. Auto-updater integration
4. Code signing for distribution

Example electron-builder setup:
```bash
npm install --save-dev electron-builder
```

Add to package.json:
```json
{
  "build": {
    "appId": "com.yourcompany.yourapp",
    "directories": {
      "output": "dist-electron"
    },
    "files": [
      "electron/**/*",
      ".next/**/*",
      "public/**/*",
      "package.json"
    ]
  },
  "scripts": {
    "build:electron": "next build && electron-builder"
  }
}
```

## Troubleshooting

### White flash on startup
- Ensure `show: false` and `ready-to-show` pattern is used
- Set `backgroundColor` to match your app

### DevTools won't open
- Check the keyboard shortcut handler in main.js
- Use `mainWindow.webContents.openDevTools()` in dev mode

### IPC not working
- Verify preload.js path is correct in BrowserWindow options
- Check browser console for contextBridge errors
- Ensure the IPC channel names match between main/preload/renderer

### Next.js API routes not working
- API routes work normally via fetch to localhost:3000
- For production, consider using IPC for native operations instead
