FROM node:20-slim

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Install git (required for build-app state management)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy runner script
COPY scripts/build-app-runner.sh /usr/local/bin/build-app-runner
RUN chmod +x /usr/local/bin/build-app-runner

WORKDIR /app

# Environment variables (override at runtime)
ENV BUILD_APP_MODEL=sonnet
ENV BUILD_APP_MAX_ITERATIONS=50
ENV BUILD_APP_BUDGET_PER_ITER=5
ENV BUILD_APP_TOTAL_BUDGET=100

# Entry point: pass project directory as argument
# Usage: docker run -e ANTHROPIC_API_KEY=... -e SLACK_WEBHOOK_URL=... -v /path/to/project:/app build-app /app
ENTRYPOINT ["build-app-runner", "--skip-permissions"]
