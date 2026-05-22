# Privacy Notice

This document describes what technical data is processed by the TS Discord Bridge beta installer and the beta license check.

## License check

The public beta build performs a license validation request to the maintainer's license server.

The current beta uses a shared beta license key. The license server does not require a user account and does not intentionally collect or store:

- Discord bot tokens
- Discord guild IDs
- Discord channel IDs
- TeamSpeak passwords
- TeamSpeak WebQuery API keys
- TeamSpeak hostnames
- TeamSpeak usernames
- TeamSpeak channel names

The license request is used only to check whether the beta build is still allowed to run.

## Server access logs

Like with normal web server access, the license server or reverse proxy may process technical access data in server logs, for example:

- IP address
- timestamp
- request path
- HTTP status code
- user-agent

These logs are used for operation, troubleshooting, abuse prevention, and security.

## Log retention

Access logs should only be kept for a limited time and should not be used to create personal profiles.

Recommended retention for the beta phase:

- access logs: 7 to 14 days
- error logs: 14 to 30 days

## No account system

The current beta license check does not use personal user accounts.

The shared beta key is not intended to identify an individual user.

## Changes

If the license system changes in the future, for example by using individual license keys, binding licenses to Discord guild IDs, or binding licenses to TeamSpeak hosts, this privacy notice should be updated before release.
