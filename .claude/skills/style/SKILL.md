---
name: style
description: Transform UI into a chosen aesthetic. Supports 10 themes — aurora, brutalist, cyberpunk, dark-premium, glassmorphism, minimalist, neumorphism, organic, retro, swiss. Invoke as `/style <theme>` or without argument to choose interactively.
---

# Style Skill

Transform a UI into a specific visual aesthetic. This skill consolidates 10 style themes into one.

## Usage

```
/style <theme>        # Apply a specific theme directly
/style                # Show theme menu and let user choose
```

## Available Themes

| Theme | Description | Best For |
|-------|-------------|----------|
| `aurora` | Soft gradient meshes, dreamy color blends | Creative tools, SaaS landing pages, wellness |
| `brutalist` | Raw, bold, harsh contrasts, monospace | Creative agencies, art portfolios, counter-culture |
| `cyberpunk` | Neon on dark, glitch effects, angular shapes | Gaming, NFT, security tools, sci-fi |
| `dark-premium` | Rich dark tones, subtle glow, refined details | Developer tools, SaaS dashboards, fintech |
| `glassmorphism` | Frosted glass, blur, depth over gradient backgrounds | Dashboards, iOS-style apps, premium SaaS |
| `minimalist` | Whitespace, grayscale, restrained typography | Portfolios, documentation, editorial |
| `neumorphism` | Embossed/debossed soft UI, dual shadows | Music players, control panels, settings |
| `organic` | Earthy tones, flowing curves, warm textures | Food, wellness, eco, community |
| `retro` | 80s/90s neon, pixel fonts, scanlines | Gaming, entertainment, music platforms |
| `swiss` | Grid-based, Helvetica, mathematical precision | Corporate, news, data, institutional |

---

## Shared Workflow

**All themes use a preview-first approach:**

1. **Preview Phase**: Transform a single representative component (button, card, or form) to demonstrate the style
2. **Review**: User reviews the preview and provides feedback or approval
3. **Apply Phase**: Once approved, apply the style systematically across the codebase

**Commands**:
- `preview` - Show a sample transformation before making changes
- `apply` - Apply the style to specified components/files
- `apply all` - Apply across the entire codebase (with confirmation)

---

## Theme: Aurora

### Overview
Dreamy, ethereal interfaces using soft gradient meshes that evoke the northern lights. Glass-like surfaces, flowing color blends, smooth animations. Premium and modern.

### When to Use
Creative agencies, music/audio platforms, meditation/wellness apps, modern SaaS landing pages, portfolio sites, premium product pages.

### Color Palette

| Role | Hex | Usage |
|------|-----|-------|
| Background | `#0F0F1A` | Deep navy |
| Surface | `rgba(255,255,255,0.05)` | Glass cards |
| Aurora 1 | `#7C3AED` | Violet mesh |
| Aurora 2 | `#EC4899` | Pink mesh |
| Aurora 3 | `#06B6D4` | Cyan mesh |
| Aurora 4 | `#10B981` | Emerald mesh |
| Text | `#FFFFFF` | Primary |
| Text Muted | `rgba(255,255,255,0.7)` | Secondary |

### Key Effects

```css
/* Aurora mesh background */
background-color: #0F0F1A;
background-image:
  radial-gradient(at 40% 20%, rgba(124, 58, 237, 0.4) 0px, transparent 50%),
  radial-gradient(at 80% 0%, rgba(236, 72, 153, 0.3) 0px, transparent 50%),
  radial-gradient(at 0% 50%, rgba(6, 182, 212, 0.3) 0px, transparent 50%),
  radial-gradient(at 80% 100%, rgba(124, 58, 237, 0.2) 0px, transparent 50%),
  radial-gradient(at 0% 100%, rgba(16, 185, 129, 0.2) 0px, transparent 50%);

/* Glass card */
background: rgba(255, 255, 255, 0.05);
backdrop-filter: blur(12px);
border: 1px solid rgba(255, 255, 255, 0.1);

/* Colored glow shadows */
box-shadow: 0 0 60px rgba(124, 58, 237, 0.3);

/* Soft radius */
border-radius: 16-32px;
```

### Component Patterns

**Button:**
```jsx
// Primary gradient
<button className="px-6 py-3 text-sm font-medium text-white bg-gradient-to-r from-violet-600 to-pink-600 rounded-xl shadow-lg shadow-violet-500/25 hover:shadow-xl hover:shadow-violet-500/40 hover:scale-[1.02] active:scale-[0.98] transition-all duration-300">
  Get Started
</button>

// Glass secondary
<button className="px-6 py-3 text-sm font-medium text-white bg-white/5 backdrop-blur-sm border border-white/10 rounded-xl hover:bg-white/10 hover:border-white/20 transition-all duration-300">
  Learn More
</button>
```

**Card:**
```jsx
<div className="relative p-8 bg-white/5 backdrop-blur-xl border border-white/10 rounded-2xl shadow-xl shadow-black/20 overflow-hidden">
  <div className="absolute -top-20 -right-20 w-40 h-40 bg-gradient-to-br from-violet-500/30 to-transparent blur-3xl" />
  <div className="relative z-10">
    <div className="w-12 h-12 bg-gradient-to-br from-violet-500 to-pink-500 rounded-xl shadow-lg shadow-violet-500/30 flex items-center justify-center">
      <span className="text-white text-xl">✦</span>
    </div>
    <h3 className="mt-6 text-xl font-semibold text-white">Title</h3>
    <p className="mt-3 text-white/70 leading-relaxed">Description text here.</p>
  </div>
</div>
```

**Input:**
```jsx
<div className="space-y-2">
  <label className="text-sm font-medium text-white/90">Email</label>
  <input type="email" className="w-full px-4 py-3 text-white placeholder:text-white/40 bg-white/5 backdrop-blur-sm border border-white/10 rounded-xl focus:outline-none focus:border-violet-500/50 focus:bg-white/10 transition-all duration-300" placeholder="you@example.com" />
</div>
```

### Transformation Steps
1. Dark navy background (`#0F0F1A`)
2. Add radial gradient mesh (multiple overlapping gradients)
3. Glass surfaces: `bg-white/5` + `backdrop-blur`
4. Gradient accents on buttons and icons
5. Colored glow shadows matching gradient palette
6. Large radius (16-32px)
7. Add floating glow orbs (blurred divs)
8. Smooth transitions (300ms+)

### Anti-Patterns
Solid flat colors, sharp corners, hard shadows, white backgrounds, no blur effects, static designs.

---

## Theme: Brutalist

### Overview
Rawness, honesty, and confrontation. Bold typography, harsh contrasts, unconventional layouts. Rejects polish in favor of authenticity.

### When to Use
Creative agencies, art portfolios, experimental projects, counter-culture brands, music/entertainment, avant-garde fashion.

### Color Palette

| Role | Hex | Usage |
|------|-----|-------|
| Primary | `#000000` | Text, primary elements |
| Background | `#FFFFFF` | Main background |
| Accent Red | `#FF0000` | Highlights |
| Accent Blue | `#0000FF` | Links, interactive |
| Accent Yellow | `#FFFF00` | Emphasis |

### Key Effects

```css
/* Thick, hard borders */
border: 4px solid black;

/* Hard offset shadows — NO blur */
box-shadow: 4px 4px 0 0 #000000;
box-shadow: 8px 8px 0 0 #000000;

/* Zero radius always */
border-radius: 0;

/* Monospace typography */
font-family: 'Space Mono', 'Courier New', monospace;

/* No transitions */
transition: none;
```

### Component Patterns

**Button:**
```jsx
<button className="px-8 py-4 text-base font-bold uppercase tracking-widest text-black bg-yellow-400 border-4 border-black shadow-[4px_4px_0_0_#000] hover:shadow-[8px_8px_0_0_#000] hover:-translate-x-1 hover:-translate-y-1 active:shadow-none active:translate-x-1 active:translate-y-1 cursor-pointer" style={{ fontFamily: "'Space Mono', monospace" }}>
  CLICK HERE
</button>
```

**Card:**
```jsx
<article className="bg-white border-4 border-black shadow-[8px_8px_0_0_#000]">
  <div className="border-b-4 border-black p-4 bg-blue-600">
    <span className="text-xs font-bold uppercase tracking-widest text-white" style={{ fontFamily: "'Space Mono', monospace" }}>CATEGORY</span>
  </div>
  <div className="p-6">
    <h2 className="text-3xl font-black uppercase leading-none" style={{ fontFamily: "'Space Mono', monospace" }}>BOLD TITLE</h2>
    <p className="mt-4 text-sm leading-relaxed" style={{ fontFamily: "'Space Mono', monospace" }}>Raw, unfiltered content. No pretense.</p>
    <a href="#" className="mt-6 inline-block text-sm font-bold uppercase text-blue-600 border-b-2 border-blue-600 hover:bg-blue-600 hover:text-white px-1">READ MORE →</a>
  </div>
</article>
```

**Input:**
```jsx
<div>
  <label className="block text-sm font-bold uppercase tracking-widest mb-2" style={{ fontFamily: "'Space Mono', monospace" }}>YOUR EMAIL</label>
  <input type="email" className="w-full px-4 py-3 text-base bg-white border-4 border-black focus:outline-none focus:shadow-[4px_4px_0_0_#000] placeholder:text-gray-400" style={{ fontFamily: "'Space Mono', monospace" }} placeholder="EMAIL@DOMAIN.COM" />
</div>
```

### Transformation Steps
1. Remove all border-radius (set to 0)
2. Add thick borders (2-4px solid black)
3. Replace soft shadows with hard offset shadows (no blur)
4. Switch to monospace or heavy display font
5. High contrast: black, white, primary color accents
6. Remove transitions (state changes instant)
7. Break symmetry: intentionally awkward spacing

### Anti-Patterns
Rounded corners, subtle gradients, soft shadows, smooth transitions, muted colors, symmetric layouts.

---

## Theme: Cyberpunk

### Overview
High-tech dystopian future. Neon colors on dark backgrounds, glitch effects, chromatic aberration, angular shapes, HUD decorations.

### When to Use
Gaming platforms, tech startups, sci-fi content, AR/VR, NFT/crypto, security tools, music production.

### Color Palette

| Role | Hex | Usage |
|------|-----|-------|
| Background | `#0D0D12` | Void black |
| Surface | `#15151D` | Cards, panels |
| Primary | `#00F0FF` | Electric cyan |
| Secondary | `#FF00AA` | Hot pink |
| Accent | `#39FF14` | Toxic green |
| Text | `#FFFFFF` | Primary |
| Text Dim | `#8888AA` | Secondary |

### Key Effects

```css
/* Neon glow */
box-shadow: 0 0 5px #00F0FF, 0 0 10px #00F0FF, 0 0 20px #00F0FF, 0 0 40px #00F0FF;
text-shadow: 0 0 10px #00F0FF;

/* Chromatic aberration */
text-shadow: -2px 0 #FF00AA, 2px 0 #00F0FF;

/* Cut corners */
clip-path: polygon(0 10px, 10px 0, calc(100% - 10px) 0, 100% 10px,
  100% calc(100% - 10px), calc(100% - 10px) 100%, 10px 100%, 0 calc(100% - 10px));

/* HUD borders */
border: 1px solid #00F0FF;
box-shadow: 0 0 10px #00F0FF, inset 0 0 10px rgba(0, 240, 255, 0.1);

/* Tech fonts */
font-family: 'Orbitron', 'Audiowide', sans-serif; /* headings */
font-family: 'Share Tech Mono', 'Roboto Mono', monospace; /* body */
```

### Component Patterns

**Button:**
```jsx
<button className="relative px-8 py-3 text-sm font-bold uppercase tracking-[0.2em] text-[#0D0D12] bg-[#00F0FF] shadow-[0_0_20px_#00F0FF,0_0_40px_#00F0FF] hover:shadow-[0_0_30px_#00F0FF,0_0_60px_#00F0FF,0_0_80px_#00F0FF] hover:scale-105 active:scale-95 transition-all duration-200" style={{ fontFamily: "'Rajdhani', sans-serif", clipPath: 'polygon(10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%, 0 10px)' }}>
  INITIALIZE
</button>
```

**Card:**
```jsx
<div className="relative p-6 bg-[#15151D] border border-[#00F0FF]/50 shadow-[0_0_20px_rgba(0,240,255,0.1),inset_0_0_30px_rgba(0,240,255,0.05)]" style={{ clipPath: 'polygon(0 15px, 15px 0, calc(100% - 15px) 0, 100% 15px, 100% calc(100% - 15px), calc(100% - 15px) 100%, 15px 100%, 0 calc(100% - 15px))' }}>
  <div className="absolute top-0 left-0 w-4 h-4 border-t-2 border-l-2 border-[#00F0FF]" />
  <div className="absolute top-0 right-0 w-4 h-4 border-t-2 border-r-2 border-[#00F0FF]" />
  <div className="absolute bottom-0 left-0 w-4 h-4 border-b-2 border-l-2 border-[#00F0FF]" />
  <div className="absolute bottom-0 right-0 w-4 h-4 border-b-2 border-r-2 border-[#00F0FF]" />
  <div className="flex items-center gap-2 mb-4">
    <div className="w-2 h-2 bg-[#39FF14] rounded-full shadow-[0_0_10px_#39FF14]" />
    <span className="text-xs text-[#39FF14] uppercase tracking-widest" style={{ fontFamily: "'Share Tech Mono', monospace" }}>SYSTEM ONLINE</span>
  </div>
  <h3 className="text-2xl text-[#00F0FF] uppercase" style={{ fontFamily: "'Orbitron', sans-serif", textShadow: '0 0 10px #00F0FF' }}>DATA CORE</h3>
  <p className="mt-3 text-[#8888AA]" style={{ fontFamily: "'Share Tech Mono', monospace" }}>Processing encrypted data streams.</p>
</div>
```

**Input:**
```jsx
<div>
  <label className="block text-xs text-[#00F0FF] uppercase tracking-[0.2em] mb-2" style={{ fontFamily: "'Share Tech Mono', monospace" }}>ACCESS CODE</label>
  <input type="text" className="w-full px-4 py-3 text-[#00F0FF] placeholder:text-[#00F0FF]/40 bg-[#0D0D12] border border-[#00F0FF]/50 shadow-[inset_0_0_10px_rgba(0,240,255,0.1)] focus:outline-none focus:border-[#00F0FF] focus:shadow-[0_0_20px_rgba(0,240,255,0.2),inset_0_0_15px_rgba(0,240,255,0.15)] transition-all duration-200" style={{ fontFamily: "'Share Tech Mono', monospace" }} placeholder="ENTER CODE..." />
</div>
```

### Transformation Steps
1. Dark void background (`#0D0D12`)
2. Apply neon colors (cyan, pink, green)
3. Add glow: `box-shadow` and `text-shadow` with neon values
4. Switch to tech fonts (Orbitron, Share Tech Mono)
5. Cut corners via `clip-path`
6. Add HUD corner bracket decorations
7. Chromatic aberration on key headings
8. Add grid background overlay

### Anti-Patterns
Soft rounded corners, pastel colors, warm tones, serif fonts, soft shadows, organic shapes.

---

## Theme: Dark Premium

### Overview
Sophisticated modern interfaces. Rich dark tones, carefully placed glow accents, subtle gradients. Common in developer tools, premium SaaS, fintech.

### When to Use
Developer tools, SaaS dashboards, finance/trading apps, modern productivity, analytics.

### Color Palette

| Role | Hex | Usage |
|------|-----|-------|
| Background | `#0A0A0F` | Main |
| Surface 1 | `#12121A` | Cards |
| Surface 2 | `#1A1A24` | Hover |
| Border | `#2A2A35` | Subtle |
| Border Hover | `#3A3A45` | Hover |
| Text Primary | `#FAFAFA` | Headlines |
| Text Secondary | `#A1A1AA` | Body |
| Accent | `#6366F1` | Primary actions |
| Accent Light | `#818CF8` | Glow |

### Key Effects

```css
/* Subtle gradient mesh */
background: radial-gradient(at 40% 20%, rgba(99, 102, 241, 0.15) 0px, transparent 50%),
            radial-gradient(at 80% 0%, rgba(139, 92, 246, 0.1) 0px, transparent 50%);

/* Glow accent */
box-shadow: 0 0 20px rgba(99, 102, 241, 0.3);

/* Gradient border */
background: linear-gradient(#12121A, #12121A) padding-box,
            linear-gradient(135deg, #6366F1, #8B5CF6) border-box;
border: 1px solid transparent;

/* Radius scale */
border-radius: 8-16px;
```

### Component Patterns

**Button:**
```jsx
// Primary
<button className="px-5 py-2.5 text-sm font-medium text-white bg-indigo-600 rounded-lg shadow-lg shadow-indigo-500/25 hover:bg-indigo-500 hover:shadow-xl hover:shadow-indigo-500/30 active:scale-[0.98] focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 focus:ring-offset-[#0A0A0F] transition-all duration-200">
  Get Started
</button>

// Secondary
<button className="px-5 py-2.5 text-sm font-medium text-zinc-300 bg-[#1A1A24] border border-[#2A2A35] rounded-lg hover:bg-[#24242E] hover:border-[#3A3A45] hover:text-white active:scale-[0.98] transition-all duration-200">
  Learn More
</button>
```

**Card:**
```jsx
<div className="p-6 bg-[#12121A] border border-[#2A2A35] rounded-xl hover:border-[#3A3A45] transition-colors duration-200">
  <div className="flex items-center justify-between">
    <div className="w-10 h-10 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-lg shadow-lg shadow-indigo-500/25 flex items-center justify-center">
      <span className="text-white">📊</span>
    </div>
    <span className="px-2.5 py-1 text-xs font-medium text-emerald-400 bg-emerald-400/10 rounded-full border border-emerald-400/20">Active</span>
  </div>
  <h3 className="mt-4 text-lg font-semibold text-white">Analytics</h3>
  <p className="mt-2 text-sm text-zinc-400 leading-relaxed">Real-time metrics and insights.</p>
  <div className="mt-6 pt-4 border-t border-[#2A2A35] flex items-center justify-between">
    <span className="text-2xl font-bold text-white">$12,450</span>
    <span className="text-sm text-emerald-400">↑ +12.5%</span>
  </div>
</div>
```

**Input:**
```jsx
<div className="space-y-2">
  <label className="text-sm font-medium text-zinc-300">Email</label>
  <input type="email" className="w-full px-4 py-2.5 text-sm text-white placeholder:text-zinc-500 bg-[#12121A] border border-[#2A2A35] rounded-lg hover:border-[#3A3A45] focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 transition-all duration-200" placeholder="you@example.com" />
</div>
```

### Transformation Steps
1. Deep dark background (`#0A0A0F`)
2. Cards on slightly lighter surface (`#12121A`)
3. Indigo/purple accent with glow shadow
4. Subtle borders that lighten on hover
5. Text: white > zinc-400 > zinc-500 hierarchy
6. Status badges: colored text + 10% opacity background
7. 150-200ms transitions

### Anti-Patterns
Pure black, white backgrounds, harsh color contrasts, no glow on accents, too many bright colors.

---

## Theme: Glassmorphism

### Overview
Frosted glass effect using blur, transparency, and subtle borders. Elements float over vibrant gradient backgrounds, creating depth through translucency.

### When to Use
Modern dashboards, iOS/macOS-inspired apps, premium SaaS, creative tools, landing pages.

### Color Palette

| Role | Value | Usage |
|------|-------|-------|
| Glass Surface | `rgba(255,255,255,0.15)` | Cards |
| Glass Light | `rgba(255,255,255,0.25)` | Elevated |
| Glass Border | `rgba(255,255,255,0.2)` | Borders |
| Text | `#FFFFFF` | Primary |
| Text Secondary | `rgba(255,255,255,0.7)` | Secondary |

**Background gradient options:**
```css
linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* Purple */
linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); /* Cyan */
linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); /* Dark */
```

### Key Effects

```css
/* Core glass */
background: rgba(255, 255, 255, 0.15);
backdrop-filter: blur(12px);
-webkit-backdrop-filter: blur(12px);
border: 1px solid rgba(255, 255, 255, 0.2);

/* Radius */
border-radius: 12-32px;

/* Shadows */
box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
```

### Component Patterns

**Button:**
```jsx
<button className="px-6 py-3 text-sm font-medium text-white bg-white/20 backdrop-blur-md border border-white/30 rounded-xl shadow-lg shadow-black/10 hover:bg-white/30 hover:shadow-xl hover:scale-[1.02] active:scale-[0.98] focus:outline-none focus:ring-2 focus:ring-white/50 transition-all duration-300">
  Get Started
</button>
```

**Card:**
```jsx
<div className="p-8 bg-white/10 backdrop-blur-xl border border-white/20 rounded-2xl shadow-xl shadow-black/10">
  <div className="flex items-center gap-4">
    <div className="w-12 h-12 bg-gradient-to-br from-cyan-400 to-blue-500 rounded-xl shadow-lg shadow-cyan-500/30 flex items-center justify-center">
      <span className="text-white text-xl">✦</span>
    </div>
    <div>
      <h3 className="text-lg font-semibold text-white">Dashboard</h3>
      <p className="text-sm text-white/70">View your analytics</p>
    </div>
  </div>
  <p className="mt-6 text-white/80 leading-relaxed">Access real-time insights.</p>
  <button className="mt-6 w-full py-3 bg-white/20 backdrop-blur-sm border border-white/30 rounded-xl text-white font-medium hover:bg-white/30 transition-all duration-300">
    Open Dashboard
  </button>
</div>
```

**Input:**
```jsx
<div className="space-y-2">
  <label className="text-sm font-medium text-white/90">Email</label>
  <input type="email" className="w-full px-4 py-3 text-white placeholder:text-white/50 bg-white/10 backdrop-blur-md border border-white/20 rounded-xl focus:outline-none focus:border-white/40 focus:bg-white/15 transition-all duration-300" placeholder="you@example.com" />
</div>
```

### Transformation Steps
1. Add vibrant gradient background to container/page
2. Apply glass: `bg-white/10-25` + `backdrop-blur-md/xl`
3. Glass borders: `border border-white/20`
4. Generous radius (12-32px)
5. Low-opacity soft shadows
6. White text with opacity variations
7. 300ms smooth transitions

### Anti-Patterns
Solid opaque backgrounds on glass, sharp corners, hard shadows, no background behind glass, too much blur (>20px gets muddy), black borders.

---

## Theme: Minimalist

### Overview
Strips away unnecessary elements to focus purely on content. Inspired by Swiss/International design and Japanese minimalism. Emphasizes whitespace, typography, and restrained color.

### When to Use
Portfolios, documentation, content-focused apps, premium/luxury brands, editorial/publishing.

### Color Palette

| Role | Hex | Tailwind | Usage |
|------|-----|----------|-------|
| Text | `#1A1A1A` | gray-900 | Headlines |
| Secondary | `#6B7280` | gray-500 | Body |
| Background | `#FFFFFF` | white | Main |
| Surface | `#FAFAFA` | gray-50 | Cards |
| Accent | `#2563EB` | blue-600 | CTAs (sparingly) |
| Border | `#E5E7EB` | gray-200 | Dividers |

### Key Effects

```css
/* No gradients, no shadows */
/* Typography-driven design */
font-family: 'Inter', -apple-system, sans-serif;

/* Generous whitespace */
section padding: 96-128px;
component spacing: 24-48px;

/* Minimal radius */
border-radius: 0-8px;

/* Subtle borders */
border: 1px solid #E5E7EB;

/* Minimal transition */
transition: opacity 200ms ease, color 200ms ease;
```

### Component Patterns

**Button:**
```jsx
// Primary (outlined)
<button className="px-6 py-3 text-sm font-medium tracking-wide uppercase text-gray-900 bg-transparent border border-gray-900 hover:bg-gray-900 hover:text-white focus:outline-none focus:ring-1 focus:ring-gray-900 focus:ring-offset-4 transition-colors duration-200">
  Learn More
</button>

// Text link style
<button className="text-sm font-medium text-gray-600 hover:text-gray-900 border-b border-transparent hover:border-gray-900 transition-colors duration-200">
  View All
</button>
```

**Card:**
```jsx
<article className="max-w-2xl py-12 border-t border-gray-200">
  <time className="text-sm text-gray-500 tracking-wide uppercase">January 15, 2024</time>
  <h2 className="mt-4 text-2xl font-semibold text-gray-900 leading-tight">Article Title</h2>
  <p className="mt-4 text-gray-600 leading-relaxed">Article description with generous line height.</p>
  <a href="#" className="mt-6 inline-block text-sm font-medium text-gray-900 border-b border-gray-900 hover:border-transparent transition-colors">Read Article</a>
</article>
```

**Input:**
```jsx
<div className="space-y-2">
  <label className="text-sm font-medium text-gray-700">Email Address</label>
  <input type="email" className="w-full px-0 py-3 text-base text-gray-900 bg-transparent border-0 border-b border-gray-300 focus:border-gray-900 focus:ring-0 placeholder:text-gray-400 transition-colors" placeholder="you@example.com" />
</div>
```

### Transformation Steps
1. Remove all decoration (gradients, complex shadows, decorative borders)
2. Reduce to grayscale + one accent
3. Double or triple existing spacing
4. Establish typography hierarchy with 2-3 sizes
5. Replace borders with whitespace where possible
6. Remove animations except essential transitions

### Anti-Patterns
Multiple accent colors, decorative icons, background patterns, complex shadows, rounded corners everywhere, unnecessary animations, visual clutter.

---

## Theme: Neumorphism

### Overview
Soft, tactile UI with elements appearing extruded from or pressed into the background. Created through dual shadows on a monochromatic surface.

### When to Use
Music players, calculators, control panels, smart home interfaces, settings screens.

### Color Palette

| Role | Hex | Usage |
|------|-----|-------|
| Background | `#E0E5EC` | Main (same as surface) |
| Shadow Light | `#FFFFFF` | Top-left highlight |
| Shadow Dark | `#A3B1C6` | Bottom-right shadow |
| Text | `#31344B` | Headlines |
| Text Secondary | `#626473` | Body |
| Accent | `#6C63FF` | Active states only |

### Key Effects

```css
/* Raised (embossed) */
background: #E0E5EC;
box-shadow: 8px 8px 16px #A3B1C6, -8px -8px 16px #FFFFFF;

/* Inset (debossed) — for inputs, pressed states */
box-shadow: inset 8px 8px 16px #A3B1C6, inset -8px -8px 16px #FFFFFF;

/* NO visible borders */
border: none;

/* Generous radius */
border-radius: 16-32px;
```

### Component Patterns

**Button:**
```jsx
<button className="px-8 py-4 text-sm font-semibold text-[#31344B] bg-[#E0E5EC] rounded-2xl shadow-[8px_8px_16px_#A3B1C6,-8px_-8px_16px_#FFFFFF] hover:shadow-[4px_4px_8px_#A3B1C6,-4px_-4px_8px_#FFFFFF] active:shadow-[inset_4px_4px_8px_#A3B1C6,inset_-4px_-4px_8px_#FFFFFF] transition-shadow duration-200 focus:outline-none">
  Press Me
</button>
```

**Card:**
```jsx
<div className="p-8 bg-[#E0E5EC] rounded-3xl shadow-[12px_12px_24px_#A3B1C6,-12px_-12px_24px_#FFFFFF]">
  <div className="w-16 h-16 bg-[#E0E5EC] rounded-2xl shadow-[inset_4px_4px_8px_#A3B1C6,inset_-4px_-4px_8px_#FFFFFF] flex items-center justify-center">
    <span className="text-2xl">🎵</span>
  </div>
  <h3 className="mt-6 text-xl font-semibold text-[#31344B]">Now Playing</h3>
  <p className="mt-2 text-[#626473]">Artist - Song Title</p>
  <div className="mt-6 flex items-center justify-center gap-4">
    <button className="w-12 h-12 bg-[#E0E5EC] rounded-full shadow-[4px_4px_8px_#A3B1C6,-4px_-4px_8px_#FFFFFF] active:shadow-[inset_2px_2px_4px_#A3B1C6,inset_-2px_-2px_4px_#FFFFFF] transition-shadow flex items-center justify-center text-[#626473]">⏮</button>
    <button className="w-16 h-16 bg-[#6C63FF] rounded-full shadow-[4px_4px_8px_#A3B1C6,-4px_-4px_8px_#FFFFFF] active:shadow-[inset_2px_2px_4px_rgba(0,0,0,0.2)] transition-shadow flex items-center justify-center text-white text-xl">▶</button>
    <button className="w-12 h-12 bg-[#E0E5EC] rounded-full shadow-[4px_4px_8px_#A3B1C6,-4px_-4px_8px_#FFFFFF] active:shadow-[inset_2px_2px_4px_#A3B1C6,inset_-2px_-2px_4px_#FFFFFF] transition-shadow flex items-center justify-center text-[#626473]">⏭</button>
  </div>
</div>
```

**Input:**
```jsx
<div>
  <label className="block text-sm font-medium text-[#626473] mb-3">Search</label>
  <div className="px-6 py-4 bg-[#E0E5EC] rounded-2xl shadow-[inset_4px_4px_8px_#A3B1C6,inset_-4px_-4px_8px_#FFFFFF] flex items-center gap-3">
    <span className="text-[#A3B1C6]">🔍</span>
    <input type="text" className="flex-1 bg-transparent text-[#31344B] placeholder:text-[#A3B1C6] focus:outline-none" placeholder="Type to search..." />
  </div>
</div>
```

### Transformation Steps
1. Set monochromatic background (`#E0E5EC`)
2. Remove ALL borders (depth comes from shadows only)
3. Add dual shadows: light top-left + dark bottom-right
4. Use generous radius (16-32px)
5. Match component background to page background
6. Use inset shadows for inputs and pressed states
7. Accent color only for active/selected states

### Anti-Patterns
Visible borders, mismatched backgrounds, too much shadow contrast, small radius, mixing shadow styles, white backgrounds, too many raised elements.

---

## Theme: Organic

### Overview
Soft, flowing curves with earthy color palettes. Creates warmth and approachability through natural shapes, hand-drawn elements, and textures that evoke nature.

### When to Use
Wellness/health apps, food/restaurant sites, eco-friendly brands, children's products, community platforms, artisan businesses.

### Color Palette

| Role | Hex | Usage |
|------|-----|-------|
| Background | `#FAF7F2` | Cream |
| Primary | `#2D5A3D` | Forest green |
| Secondary | `#8B4513` | Saddle brown |
| Accent | `#E07B39` | Burnt orange |
| Text | `#2C2C2C` | Charcoal |
| Text Secondary | `#5C5C5C` | Gray |
| Border | `#E5DDD3` | Tan |

### Key Effects

```css
/* Organic/irregular radius */
border-radius: 24px 16px 28px 20px; /* asymmetric */
border-radius: 60% 40% 30% 70% / 60% 30% 70% 40%; /* blob */

/* Warm shadows */
box-shadow: 0 8px 30px rgba(139, 69, 19, 0.1);

/* Serif + rounded sans font pairing */
font-family: 'Fraunces', 'Playfair Display', serif; /* headings */
font-family: 'Nunito', 'Open Sans', sans-serif; /* body */

/* Gentle animations */
transition: all 300ms cubic-bezier(0.34, 1.56, 0.64, 1);
```

### Component Patterns

**Button:**
```jsx
<button className="px-8 py-3 text-base font-semibold text-white bg-[#2D5A3D] rounded-[12px_8px_16px_10px] shadow-[0_4px_20px_rgba(45,90,61,0.25)] hover:bg-[#4A7C5B] hover:shadow-[0_6px_25px_rgba(45,90,61,0.3)] hover:-translate-y-0.5 active:translate-y-0 transition-all duration-300 ease-out" style={{ fontFamily: "'Nunito', sans-serif" }}>
  Explore Nature
</button>
```

**Card:**
```jsx
<div className="p-8 bg-white rounded-[24px_16px_28px_20px] shadow-[0_8px_30px_rgba(139,69,19,0.1)] border border-[#E5DDD3] hover:shadow-[0_12px_40px_rgba(139,69,19,0.15)] hover:-translate-y-1 transition-all duration-300">
  <div className="w-16 h-16 bg-gradient-to-br from-[#E07B39] to-[#C4704A] rounded-[60%_40%_30%_70%/60%_30%_70%_40%] flex items-center justify-center shadow-[0_4px_15px_rgba(224,123,57,0.3)]">
    <span className="text-2xl">🌿</span>
  </div>
  <h3 className="mt-6 text-2xl font-bold text-[#2C2C2C]" style={{ fontFamily: "'Fraunces', serif" }}>Farm Fresh</h3>
  <p className="mt-3 text-[#5C5C5C] leading-relaxed" style={{ fontFamily: "'Nunito', sans-serif" }}>Locally sourced ingredients from sustainable farms.</p>
  <a href="#" className="mt-6 inline-flex items-center gap-2 text-[#2D5A3D] font-semibold hover:text-[#4A7C5B] hover:gap-3 transition-all duration-300">Learn More <span>→</span></a>
</div>
```

**Input:**
```jsx
<div className="space-y-2">
  <label className="block text-sm font-medium text-[#5C5C5C]" style={{ fontFamily: "'Nunito', sans-serif" }}>Your Name</label>
  <input type="text" className="w-full px-5 py-3 text-[#2C2C2C] placeholder:text-[#B8A07E] bg-white border border-[#E5DDD3] rounded-[10px_14px_12px_16px] shadow-[0_2px_8px_rgba(139,69,19,0.04)] focus:outline-none focus:border-[#2D5A3D] focus:shadow-[0_4px_12px_rgba(45,90,61,0.1)] transition-all duration-300" style={{ fontFamily: "'Nunito', sans-serif" }} placeholder="Enter your name..." />
</div>
```

### Transformation Steps
1. Warm cream background (`#FAF7F2`)
2. Switch to earth tone palette (greens, browns, oranges)
3. Apply irregular, asymmetric border-radius
4. Serif headings + rounded sans body font pairing
5. Warm-toned diffuse shadows
6. Blob/organic shapes for decorative elements
7. Smooth, slightly bouncy transitions

### Anti-Patterns
Pure white, sharp corners, cold blue/gray colors, geometric precision, hard shadows, modern sans-serif only, stiff animations.

---

## Theme: Retro

### Overview
80s/90s synthwave aesthetic. Neon colors on dark backgrounds, pixel elements, scanlines, glow effects, nostalgic typography.

### When to Use
Gaming platforms, entertainment sites, music platforms, nostalgic brands, creative portfolios, event/party sites.

### Color Palette

| Role | Hex | Usage |
|------|-----|-------|
| Background | `#0D0221` | Deep purple |
| Primary | `#FF00FF` | Neon magenta |
| Secondary | `#00FFFF` | Cyan |
| Accent | `#FF6B6B` | Coral pink |
| Text | `#FFFFFF` | Primary |
| Grid | `#541388` | Grid lines |

### Key Effects

```css
/* Neon text glow */
text-shadow: 0 0 5px #FF00FF, 0 0 10px #FF00FF, 0 0 20px #FF00FF, 0 0 40px #FF00FF;

/* Neon box glow */
box-shadow: 0 0 10px #FF00FF, 0 0 20px #FF00FF, 0 0 40px #FF00FF;

/* Scanlines overlay */
background: repeating-linear-gradient(0deg, rgba(0,0,0,0.15) 0px, rgba(0,0,0,0.15) 1px, transparent 1px, transparent 2px);

/* Grid background */
background-image: linear-gradient(#541388 1px, transparent 1px), linear-gradient(90deg, #541388 1px, transparent 1px);
background-size: 40px 40px;

/* Pixel/display fonts */
font-family: 'Press Start 2P', 'VT323', monospace;
font-family: 'Orbitron', 'Audiowide', sans-serif;

/* Sharp corners */
border-radius: 0-4px;
```

### Component Patterns

**Button:**
```jsx
<button className="px-8 py-4 text-sm uppercase tracking-widest text-white bg-transparent border-2 border-[#FF00FF] shadow-[0_0_10px_#FF00FF,0_0_20px_#FF00FF] hover:bg-[#FF00FF]/20 hover:shadow-[0_0_20px_#FF00FF,0_0_40px_#FF00FF,0_0_60px_#FF00FF] active:scale-95 transition-all duration-300" style={{ fontFamily: "'Press Start 2P', monospace", fontSize: '12px' }}>
  START GAME
</button>
```

**Card:**
```jsx
<div className="relative p-6 bg-[#0D0221]/90 border-2 border-[#00FFFF] shadow-[0_0_10px_#00FFFF,inset_0_0_20px_rgba(0,255,255,0.1)]">
  <div className="absolute inset-0 pointer-events-none opacity-20" style={{ background: 'repeating-linear-gradient(0deg, rgba(0,0,0,0.2) 0px, rgba(0,0,0,0.2) 1px, transparent 1px, transparent 2px)' }} />
  <div className="relative z-10">
    <h3 className="text-xl text-[#FF00FF] uppercase tracking-wider" style={{ fontFamily: "'Orbitron', sans-serif", textShadow: '0 0 10px #FF00FF, 0 0 20px #FF00FF' }}>HIGH SCORE</h3>
    <p className="mt-4 text-4xl text-[#00FFFF] font-bold" style={{ fontFamily: "'Press Start 2P', monospace", textShadow: '0 0 10px #00FFFF' }}>999,999</p>
  </div>
</div>
```

**Input:**
```jsx
<div>
  <label className="block text-sm text-[#00FFFF] uppercase tracking-widest mb-2" style={{ fontFamily: "'Press Start 2P', monospace", fontSize: '10px' }}>PLAYER NAME</label>
  <input type="text" className="w-full px-4 py-3 bg-[#0D0221] text-[#00FFFF] border-2 border-[#00FFFF]/50 shadow-[inset_0_0_10px_rgba(0,255,255,0.1)] focus:border-[#00FFFF] focus:shadow-[0_0_10px_#00FFFF,inset_0_0_10px_rgba(0,255,255,0.2)] focus:outline-none placeholder:text-[#00FFFF]/40 transition-all duration-300" style={{ fontFamily: "'VT323', monospace", fontSize: '20px' }} placeholder="ENTER NAME..." />
</div>
```

### Transformation Steps
1. Deep purple/black background (`#0D0221`)
2. Replace all colors with neon (pink, cyan, yellow)
3. Add glow: `text-shadow` and `box-shadow` with neon values
4. Switch to pixel/display fonts (Press Start 2P, Orbitron, VT323)
5. Add 2px neon borders with glow
6. Optional scanlines overlay for CRT effect
7. All text uppercase with tracking

### Anti-Patterns
Light backgrounds, subtle muted colors, serif fonts, soft shadows, lowercase text, modern sans-serif fonts.

---

## Theme: Swiss

### Overview
Swiss/International Typographic Style. Strict grid systems, sans-serif typography, asymmetric layouts, mathematical precision. Form follows function.

### When to Use
Corporate websites, news/media, documentation, institutional sites, data-heavy apps, government, information architecture.

### Color Palette

| Role | Hex | Usage |
|------|-----|-------|
| Primary | `#000000` | Text, key elements |
| Background | `#FFFFFF` | Main |
| Accent | `#FF0000` | Emphasis (traditional red) |
| Secondary | `#E5E5E5` | Dividers |
| Text Muted | `#666666` | Secondary text |

### Key Effects

```css
/* Helvetica or neo-grotesque */
font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;

/* 8px baseline grid — all spacing multiples of 8 */
--baseline: 8px;

/* Sharp corners always */
border-radius: 0;

/* Clean functional borders */
border: 1px solid #000000;
border-bottom: 4px solid #000000; /* Heavy rule for emphasis */

/* No decorative shadows */
/* Minimal transitions */
transition: color 150ms ease-out;
```

### Component Patterns

**Button:**
```jsx
<button className="px-6 py-3 text-sm font-medium uppercase tracking-wider text-white bg-black hover:bg-[#333333] active:bg-[#1a1a1a] focus:outline-none focus:ring-2 focus:ring-black focus:ring-offset-2 transition-colors duration-150" style={{ fontFamily: "'Helvetica Neue', Helvetica, sans-serif" }}>
  Submit
</button>
```

**Card:**
```jsx
<article className="border-t-4 border-black pt-6 pb-8" style={{ fontFamily: "'Helvetica Neue', Helvetica, sans-serif" }}>
  <div className="flex items-baseline justify-between">
    <span className="text-xs uppercase tracking-wider text-[#666666]">Category</span>
    <span className="text-xs text-[#666666]">2024.01.15</span>
  </div>
  <h2 className="mt-4 text-2xl font-bold leading-tight text-black">Clear, Objective Headline</h2>
  <p className="mt-4 text-base leading-relaxed text-[#333333]">Information presented clearly and objectively, allowing content to speak for itself.</p>
  <a href="#" className="mt-6 inline-block text-sm font-medium uppercase tracking-wider text-black border-b border-black hover:text-[#FF0000] hover:border-[#FF0000] transition-colors">Read Article →</a>
</article>
```

**Input:**
```jsx
<div>
  <label className="block text-xs uppercase tracking-wider text-[#666666] mb-2" style={{ fontFamily: "'Helvetica Neue', Helvetica, sans-serif" }}>Email Address</label>
  <input type="email" className="w-full px-0 py-3 text-base text-black bg-transparent border-0 border-b-2 border-black focus:outline-none focus:border-[#FF0000] placeholder:text-[#999999] transition-colors duration-150" style={{ fontFamily: "'Helvetica Neue', Helvetica, sans-serif" }} placeholder="you@example.com" />
</div>
```

### Transformation Steps
1. Remove all decoration (gradients, shadows, rounded corners)
2. Reduce palette to black, white, one accent (red)
3. Align all elements to 8px baseline grid
4. Switch to Helvetica/neo-grotesque sans-serif
5. Let typography hierarchy carry the design
6. Create visual interest through asymmetric layout
7. Keep only elements that serve a functional purpose

### Anti-Patterns
Decorative elements, multiple colors, rounded corners, gradients, drop shadows, script/display fonts, symmetric centered layouts, ornamental borders.
