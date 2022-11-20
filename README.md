# DiffTurret 🗼

Hacky shell script for detecting changes in websites using `curl` and `diff`. 
Can serve as alternative to [ChangeTower](https://changetower.com/) when 
combined with `cron`.
By default, a Discord bot is used to issue notifications.

## Prerequisites

For the Discord notifications to work, you need to create `discord.env` in
this directory with the following contents:

```sh
DISCORD_TOKEN="... your Discord Bot Auth Token ..."
DISCORD_CHANNEL="... the ID of the discord channel to send messages to ..."
```

The `discord` python package must be installed.
Alternatively, change `notify.py` to use any other means of notification.

## Usage

```
./check_website.sh <URL> [Regex-Pattern]
```

The Regex-Pattern will be applied to the raw Website HTML, allowing to filter
what changes will be detected.

(Add me to crontab!)

## Testing

To test whether your notification setup works, you can use

```
./check_website.sh file://$(pwd)/test/a.html
./test/swap.sh
./check_website.sh file://$(pwd)/test/a.html
```
