// The sign-in panel's switch, so any page — the nav bar, the landing hero,
// the forum — can open the one sign-in sheet mounted in the root layout
// without each carrying its own copy of the form.

export const signInPanel = $state({ open: false });

export function openSignIn(): void {
	signInPanel.open = true;
}
