# Brewmaster MDM implementation playbook

This file is written for an administrator or AI agent preparing a Brewmaster deployment. It is a deployment plan, not an executable script. Keep the installer, managed preferences and PPPC permission as separate MDM objects so each can be reviewed, scoped and removed independently.

## Required discovery

Before proposing changes, obtain and restate these answers:

| Question | Why it matters |
| --- | --- |
| Which MDM is in use: Iru, Jamf Pro, Microsoft Intune or Addigy? | Select the matching workflow below; do not guess vendor UI names. |
| Are target Macs Apple-silicon, on macOS 14 or later, and enrolled through user-approved device MDM? | Brewmaster is arm64-only and the PPPC profile needs MDM deployment. |
| How will the signed PKG be deployed: MDM app/package workflow, AutoPkg/IOTA, or Homebrew cask? | Choose one app-delivery owner; do not enable competing automatic updaters. |
| Is Brewmaster app delivery owned by Iru/IOTA or another MDM channel? | Set `AllowSelfUpdates=false` when a management channel owns app updates. |
| Which pilot group and production group are intended? | Start with a small pilot; never default to all Macs. |
| Is App Management required for Brewmaster-managed cask application changes? | Deploy the separate PPPC profile only when required and approved. |
| Which package-policy choices are approved? | Decide `UpdatePolicy`, confirmation, package/tap restrictions, maintenance window and critical-update values before creating a profile. |

If an answer is missing, stop and ask. Never infer authorization to deploy to all devices, grant Full Disk Access, grant administrator rights, disable confirmation, or enable actual updates.

## Download and prepare the artifacts

Use one matching public release from [paul-ej/homebrew-brewmaster](https://github.com/paul-ej/homebrew-brewmaster/releases), not files from unrelated versions:

1. `Brewmaster-<version>.pkg` — the immutable signed installer.
2. `com.paul-ej.brewmaster.plist` — an inspection/import starting point, not an enforced profile by itself.
3. `Brewmaster.mobileconfig` — forced managed preferences for the `com.paul-ej.brewmaster` domain.
4. `Brewmaster-AppManagement.mobileconfig` — optional, separate App Management PPPC profile.

Verify the PKG checksum against the matching release checksum before uploading it to an MDM. Lint every profile with `plutil -lint FILE`. Keep the preference domain unchanged. Before deployment, create organisation-specific copies of the `.mobileconfig` files with new top-level and payload identifiers/UUIDs; do not reuse a profile identity that already exists in the tenant. Do not turn Booleans into strings or place secrets in a profile.

The PPPC profile is intentionally narrow: it allows only `SystemPolicyAppBundles` for `com.paul-ej.brewmaster`, constrained to Developer ID team `49G9R48EJL`. It does not grant Full Disk Access, admin rights, shell access, or permission to every Homebrew subprocess. Do not add blanket permissions for `/bin/bash`, Ruby, or Homebrew to bypass a failed test.

## Create three separate MDM objects

1. **Brewmaster application** — deploy the release PKG with the MDM's normal signed-package/application mechanism. Do not wrap, re-sign, or modify the PKG.
2. **Brewmaster policy** — upload the customised `Brewmaster.mobileconfig` as a device/system configuration profile. The plain plist is only for policy review or a vendor-specific preference-import workflow.
3. **Brewmaster App Management (optional)** — upload the customised PPPC profile as a second device/system configuration profile. Scope it only where approved.

Assign all three to the pilot group. Confirm installation and configuration-profile status in the MDM before testing Brewmaster. Then use Brewmaster's **Check now** and inspect Settings to confirm the effective policy; do not treat a successful profile upload as proof of enforcement.

## Vendor routes

| MDM | Profile route | Application route | Notes |
| --- | --- | --- | --- |
| Iru | Library → create a **Custom Profile**, upload each `.mobileconfig`, then attach each profile to the selected Blueprint. | Use the approved Custom App/package delivery item in the same pilot Blueprint. | For Iru-owned delivery, set `AllowSelfUpdates=false`; do not claim an IOTA recipe changed an existing Iru assignment. [Iru Custom Profile](https://www.iru.com/library-items/3b929698-5364-46be-8945-aa2e30c0e233) |
| Jamf Pro | Devices → Configuration Profiles → Upload; use computer-level/system scope, configure General/Scope, and upload each profile separately. | Use the approved PKG deployment workflow/policy for the signed vendor PKG. | Jamf supports uploading complete `.mobileconfig` files. Keep each profile UUID unique and pilot the scope. [Jamf profile upload](https://learn.jamf.com/r/en-US/jamf-pro-documentation-current/Uploading_a_Configuration_Profile_iOS) |
| Microsoft Intune | Devices → macOS → Configuration → Create → New policy → macOS / Templates / Custom; upload one `.mobileconfig` per custom profile and select the appropriate device channel. | Use the approved macOS PKG app/deployment workflow; keep it separate from configuration profiles. | Intune does not validate custom-profile variables; do not introduce tokens unless they are required and verified. [Intune custom settings](https://learn.microsoft.com/en-us/mem/intune/configuration/custom-settings-macos) |
| Addigy | Catalog → Device Settings → New → Custom Profile; upload one `.mobileconfig`, then assign it to the pilot policy. | Use the approved Addigy app/package deployment item. | Each uploaded custom profile needs a unique `PayloadUUID`; Addigy provides profile assignment separately. [Addigy Custom Profiles](https://support.addigy.com/hc/en-us/articles/4403542439315-How-to-Configure-and-Deploy-a-Custom-Profile) |

Vendor interfaces evolve. If a listed navigation path differs in the tenant, use the linked vendor documentation and describe the equivalent custom-profile and signed-PKG flow; do not substitute a shell script or local profile installation.

## Pilot acceptance criteria

For a pilot Mac, record only non-sensitive deployment evidence:

1. The expected signed PKG version is installed in `/Applications` and the app opens.
2. Both intended profiles report installed through MDM; the PPPC profile is absent when it was not approved.
3. Settings reflects the selected managed values; a local preference change cannot override forced values.
4. `RequireUpdateConfirmation=true` produces an approval prompt, or `false` provides the expected immediate manual flow.
5. `AllowSelfUpdates=false` shows the app as managed separately when MDM owns app delivery.
6. An approved, non-production test cask operation demonstrates whether App Management is required. Do not test against critical production software.
7. Removing a pilot assignment removes only the intended MDM objects; do not delete unrelated policies or profiles.

Only expand scope after the owner accepts the pilot evidence. If a test fails, capture the MDM status and Brewmaster's reviewed diagnostics; do not grant broader permissions as a workaround.

## AI-agent output contract

When asked to configure this deployment, return a reviewable plan containing:

```text
MDM: <Iru | Jamf Pro | Microsoft Intune | Addigy>
Target scope: <named pilot group only unless explicitly approved otherwise>
App delivery owner: <MDM package workflow | IOTA | Homebrew cask>
Profiles: <policy profile>, <PPPC profile: included or intentionally omitted>
Managed policy decisions: <key/value list, including AllowSelfUpdates and RequireUpdateConfirmation>
Vendor steps: <current console path and actions>
Validation: <pilot acceptance steps and success criteria>
Rollback: <unassign/remove the three Brewmaster-specific MDM objects; preserve unrelated MDM state>
Open approvals: <anything not explicitly authorized>
```

Never upload, assign, publish, push, run package upgrades, or change an existing MDM assignment without explicit authorization. This playbook does not make a deployment fleet-ready; clean-device, OS-version, permissions, network, cancellation and update-failure acceptance testing remain required.
