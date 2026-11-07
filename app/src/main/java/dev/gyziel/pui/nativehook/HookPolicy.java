package dev.gyziel.pui.nativehook;
/** Pure Java guard, testable without Android or an LSPosed runtime. */
public final class HookPolicy {
    public static boolean supportedDevice(String maker, String brand, int sdk) {
        if (sdk < 34 || sdk > 37) return false;
        String names = ((maker == null ? "" : maker) + " " +
                (brand == null ? "" : brand)).toLowerCase(java.util.Locale.ROOT);
        return names.contains("xiaomi") || names.contains("redmi") || names.contains("poco");
    }
    private HookPolicy() {}
}
