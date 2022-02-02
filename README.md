# LaunchDarkly-Concept-Proof

## Sprint 1

Adding *segmentation* support for feature flags. We will test...

* name
* email
* country
* device
* operating system
* age (custom segment)

This segmentation is implemented by `LDUser` struct available at LaunchDarkly SDK. This struct is passing at configuration time as a parameter in the `LDClient.start(config:user:)` function.

There's a new vídeo showing the segmentation implementation.