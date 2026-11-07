package dev.gyziel.pui.nativehook;
/** Thread-local nesting prevents CTS state crossing concurrent system_server workers. */
final class ThreadScopedSwitch {
    private static final ThreadLocal<Integer> DEPTH = new ThreadLocal<>();
    static void enter() {
        Integer n = DEPTH.get();
        DEPTH.set(n == null ? 1 : n + 1);
    }
    static void exit() {
        Integer n = DEPTH.get();
        if (n == null || n <= 1) DEPTH.remove(); else DEPTH.set(n - 1);
    }
    static boolean active() {
        Integer n = DEPTH.get();
        return n != null && n > 0;
    }
    private ThreadScopedSwitch() {}
}
