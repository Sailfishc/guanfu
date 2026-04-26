// Temporary debug bridge template for own-dev-app mode only.
// Add behind a local/dev flag. Remove before production build unless the app owner explicitly keeps it.

declare global {
  interface Window {
    __APP_DEBUG__?: {
      getEditorState?: () => unknown;
      getSelection?: () => unknown;
      getBlocks?: () => unknown;
      getCanvasState?: () => unknown;
      getPerfMarks?: () => PerformanceEntry[];
      getRenderCounts?: () => Record<string, number>;
      getIpcLog?: () => unknown[];
    };
  }
}

export function installDebugBridge(getters: NonNullable<Window["__APP_DEBUG__"]>) {
  if (typeof window === "undefined") return;
  if (!import.meta.env?.DEV) return;
  window.__APP_DEBUG__ = Object.freeze({ ...getters });
}
