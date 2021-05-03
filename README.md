# Discord.js Coffee

[![Discord](https://discordapp.com/api/guilds/397479560876261377/embed.png)](https://discord.gg/mDkMbEh)

This repository is a [discord.js](https://discord.js.org) boilerplate with CoffeeScript

It provides a simple command handler based off a minimal one from my other bot [Miyako](https://github.com/pollen5/miyako)

The goal is to enjoy CoffeeScript. I knew about it before but never really used it and I wanted to get a feel of the syntax in some actual project so I decided to make this boilerplate to see CoffeeScript in action and hopefully attract interested users.

## Setup
Clone the repository (you will need `git` installed)
```sh
$ git clone https://github.com/ravener/discord.js-coffee
$ cd discord.js-coffee
```
Install Node.js v12+ if you haven't already then install dependencies:
```sh
$ npm install
```
I assume you already have experience with Discord Bots and have already made a bot account and have the token in hand, if so then rename `config.json.example` to `config.json` and fill in the required fields.

## Running
You can run the `index.js` file with `node index.js` (or with `nodemon`/`pm2` whatever you prefer) and it will use `coffeescript/register` to compile the files on the fly.

Or you can compile a full JavaScript build and run the pure output by doing `npm run build` and running the `dist/index.js` file instead.

If you changed a command use the builtin `reload`/`load` for the changes to take effect or if you changed something else then you will have to restart Node.js.

Note that if you choosed the second method you will need to re-run `npm run build` to rebuild the files.

Pre-compiling all files will result in faster loading times but slower development process, it is a good idea to run on the fly in development and pre-compile for production. However CoffeeScript compiles pretty fast so using on the fly is even good at production and will make it easier to update the production version. Just pick what you prefer.

## Commands
This boilerplate ships with 8 Commands to get you started.

- **invite** Allows users to invite your bot, calculates invite permissions from commands' permissions.
- **help** View help about commands.
- **stats** Basic statistics about the bot.
- **ping** Checks bot and API latency.

**Owner Only Commands:** (These are commands that can be used by only you: the bot owner.)
- **eval** Evaluates CoffeeScript.
- **load** Load/Reload all events or commands.
- **reload** Reloads a command or event.
- **reboot** Reboot or shutdown the bot.

Lastly if you think there is anything missing from this boilerplate that would be nice to have or something that could be improved then feel free to open an issue.

Feel free to join our [Discord Server](https://discord.gg/mDkMbEh) for any questions/discussions.

Lastly if you found this useful leaving a star will make me happy :)

## License
This boilerplate code is free to be used for any purposes under the [MIT License](LICENSE)
