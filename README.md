# Violet CLI App
Violet is a command-line interface (CLI) application written in Elixir. This app allows you to generate Jest test files for your Svelte components using a provided file path.

## Installation
To install Violet, you will need to have Elixir installed on your computer. You can download Elixir from the official website [here](https://elixir-lang.org/install.html).

Once Elixir is installed, you can follow the steps below to install Violet:

Clone the Violet repository from GitHub:

```
git clone https://github.com/LMansoldo/violet.git
cd violet
```
Install dependencies by running:

```
mix deps.get
```

Compile the code by running:
```
mix compile
```

Build the application by running:

```
mix escript.build
```

This command will create an executable file named violet in the root directory of the project.

## Usage
To use Violet, navigate to the directory where your React components are located, and run the following command:

```
./violet --unitTest <filepath>
```

Replace <filepath> with the path to your component file. This command will generate Jest test files for your component, which you can then use to test your Svelte application.
