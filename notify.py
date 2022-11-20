#!/usr/bin/env python3
import os
import sys
import discord
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("token", help="Discord Bot Auth Token")
parser.add_argument("channel", help="Channel ID, eg.: 717061234515509302")
args = parser.parse_args()

msg = ""
for line in sys.stdin.readlines():
    msg += line

client = discord.Client()

@client.event
async def on_ready():
    await client.get_channel(int(args.channel)).send(msg)
    await client.close()

client.run(args.token)
