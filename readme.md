# Asteroid 3D

## Description

This is a project to learn more about the Godot Enginge and Blender. The main focus is to learn how to make use of unit testing in Godot. The ideal would be to have a CI/CD pipeline that runs the unit tests and the game itself. The second goal is to learn how to export the game to Itch.io. and make it playable.

## Documentation

The documentation is written in Markdown and can be found in the `docs` folder.

-   [Game Design Document](docs/GameDesignDocument.md)

## Dependencies

-   Godot 4.2.1 or later
-   Blender 4.0.1 or later

### Godot Addons

-   [Godot Unit Test](https://github.com/bitwes/Gut)

## Status

This project is currently in development. The first playable version will be released on Itch.io.

### CI

So basically I tried setting up CI pipeline with Github and tried different Github actions.

-   [Godot CI](https://github.com/abarichello/godot-ci)
-   [Godot GUT CI](https://github.com/ceceppa/godot-gut-ci)

The issue was that I couldn't get the unit tests to run. After some digging I found out that it was a common Godot issue due to the import files. There is a good description of why here: https://github.com/alessandrofama/fmod-for-godot/issues/23#issuecomment-1754475551
Until this is fixed I will not be able to use Github Actions for CI and instead have to run the tests locally.

### CD

So the CD pipeline is not set up yet, but I have a plan. I will use Github Actions to build the game and then upload it to Itch.io. Most likely I will use the [Godot CI Action](https://github.com/marketplace/actions/godot-ci) for this.
