# Brewmaster policy starting points

These are generated starter policies for Brewmaster, a macOS menu-bar app for Homebrew package updates. They do not install Brewmaster or Homebrew.

| File | Use |
| --- | --- |
| [com.paul-ej.brewmaster.plist](com.paul-ej.brewmaster.plist) | Plain preference values for inspection, customisation and import into your management platform. |
| [Brewmaster.mobileconfig](Brewmaster.mobileconfig) | Unsigned Configuration profile containing forced managed preferences. Customise and deploy through MDM. |

In the public distribution repository, the release workflow refreshes both files in `Policies` after successful publication. Copies are also attached to each [Brewmaster release](https://github.com/paul-ej/homebrew-brewmaster/releases). Use release-specific files if you need to retain the starting point for a particular deployment.

## Start here

1. Download both files and review their values before deployment.
2. Choose `UpdatePolicy`: `all` for ordinary latest-version updates, `vulnerableOnly` for verified formula vulnerability fixes, `highlightedOnly` for selected packages, or `auditOnly` to disable remediation.
3. Decide whether users should confirm updates. Set `RequireUpdateConfirmation` to Boolean `true` for a prompt; leave it `false` for immediate manual updates and eligible unattended deadline updates.
4. Adjust allowed taps, package restrictions and maintenance times for your organisation.
5. Keep the preference domain **`com.paul-ej.brewmaster`** unchanged. Customise profile/payload identifiers and UUIDs, scope appropriately, and deploy the profile through your MDM.
6. Open Brewmaster, choose Check now, and review the effective policy in Settings. Validate on test Macs before broad deployment.

Do not change Boolean values into strings. Unknown or misspelled keys are ignored; use the generated names and review effective settings after deployment. `plutil -lint FILE` can check plist syntax, but syntax alone does not prove policy semantics or MDM enforcement. A plain plist copied onto disk is not an enforced policy; the app reads preferences through macOS APIs. Do not write directly into managed-preference caches.

## Defaults and keys

| Key | Default / meaning |
| --- | --- |
| `AllowSelfUpdates` | `true`; separate explicit native app-update channel. Set false on Iru-managed Macs. |
| `Enabled` | `true`; permits eligible remediation. |
| `UpdatePolicy` | `all`; latest reported available versions. |
| `UpdateCadenceDays` | `7`; grace period after first detection, **not** the check interval. |
| `RequireUpdateConfirmation` | `false`; true requires approval and leaves due automatic updates pending. |
| `AllowPackageInstallation` | `true`; explicit latest-version installation within access rules. |
| `AllowUnpinning` | `true`; offer always-confirmed Unpin & Update. Bulk/automatic updates retain pins. |
| `CriticalUpdatesEnabled` | `true`; accelerate verified critical fixes. |
| `CriticalCVSSThreshold` | `9.0`; finite numeric base score from 0 to 10. |
| `CriticalUpdateDeadlineHours` | `24`; at least one hour from first verified qualifying fix. |
| `VulnerabilityScanEnabled` | `true`; attempt supported formula vulnerability scanning. |
| `MinimumSeverity` | `high`; vulnerability-only threshold. |
| `IncludeFormulae`, `IncludeCasks` | Both `true`. |
| `AllowedTaps` | `homebrew/core`, `homebrew/cask`. Unknown/unlisted taps are blocked. |
| `AllowedPackages` | Empty; used when package allowlisting is enforced. |
| `PackageAllowlistEnforced` | `false`; enabling with an empty allowed list is invalid. |
| `HighlightedPackages` | Empty; relevant to `highlightedOnly`. |
| `ExcludedPackages` | Empty; explicit exclusions take precedence. |
| `PartialFailureReporting` | `true`; retained schema key, currently no behavioural switch. Results are always per-package. |
| `MaintenanceWindowEnabled` | `false`. |
| `MaintenanceWindowStart`, `MaintenanceWindowEnd` | `20:00`, `06:00`, local time. Overnight windows supported; identical times mean all day. |

Use real Booleans/integers/arrays and strict 24-hour `HH:mm` values. Grace period must be at least one day. Package list values must be valid Homebrew identifiers; prefer qualified identifiers. To permit a third-party tap, add its exact tap name deliberately.

## What the policy can and cannot do

The running app checks approximately every 15 minutes and at launch. Enabling Open at login helps resume checks after sign-in. Quitting the app, sleep, network/installer failures, maintenance windows and approval requirements can delay updates. Seven days is a target for an eligible attempt, not a guaranteed installation deadline.

A prompt requires a user click/approval; automatic checks never silently approve packages on the user’s behalf. Ordinary approval does not remove pins. Explicit Unpin & Update always asks for approval, even with ordinary prompts off. Exclusions, allowed taps and other policy restrictions still apply. Tap/package rules govern Brewmaster actions, not unrelated Terminal commands or Homebrew’s dependency/installation scripts.

Cask vulnerability coverage is unknown. Incomplete or unsupported scans cannot authorise vulnerability-only remediation. Ordinary `all` policy can update eligible packages without claiming a verified vulnerability fix.

Brewmaster itself is updated through its install channel after quitting the app. The running app does not upgrade its own cask. The profile is separate from that installer and should be managed separately.

Explicit installation is available by default, with fresh latest-version metadata and installed-target verification. Package/type/tap/allowlist/exclusion/window rules apply; auditOnly blocks installation. Highlighted/vulnerability selection modes govern upgrades.

Critical deadlines use supported CVSS v3.0/v3.1 base vectors retrieved from OSV by public advisory ID, and require exact available-version fix evidence. CVSS v2/v4 or absent scores remain unknown. The earlier normal/critical deadline applies without resetting the critical clock for upstream target churn; new targets require fresh matching evidence. OSV receives advisory IDs, not inventory/history. Sleep, policy, pins, approval and maintenance windows can delay execution.

## App Management PPPC

[Brewmaster-AppManagement.mobileconfig](Brewmaster-AppManagement.mobileconfig) is a separate, unsigned MDM starter profile granting only `SystemPolicyAppBundles` (App Management) to `com.paul-ej.brewmaster`, constrained to Developer ID team `49G9R48EJL`. Its requirement was checked against the installed signed app. Review it against your deployed app with `codesign -d -r- /Applications/Brewmaster.app`, customise profile identifiers/UUIDs and deploy through user-approved device MDM (for example, an Iru Custom Profile). PPPC grants cannot be enabled by manually installing this profile.

This grants neither Full Disk Access nor administrator privileges, and does not authorize every Homebrew subprocess independently. Validate actual cask upgrades on managed test devices; subprocess attribution and Homebrew's own execution behaviour can affect permission checks. Do not grant blanket permissions to `/bin/bash` or Homebrew's Ruby merely to work around attribution. This profile is separate from the generated preference templates and is not installed by the PKG. The source copy is intended for MDM upload; it is not currently a generated release asset.

For a personal Mac use System Settings → Privacy & Security → App Management, enable/add `/Applications/Brewmaster.app`, then relaunch it. [Apple's PPPC schema](https://github.com/apple/device-management/blob/release/mdm/profiles/com.apple.TCC.configuration-profile-policy.yaml) documents the service and MDM requirement.

For Iru-owned app delivery, set Boolean `AllowSelfUpdates` to false in the managed preferences payload. This disables the native Check/Download/Install & Quit self-update channel, independently of ordinary Homebrew package restrictions. It does not change external Iru assignments. No extra PPPC grant or privileged helper is needed for self-updates: macOS Installer handles its normal administrator approval.
