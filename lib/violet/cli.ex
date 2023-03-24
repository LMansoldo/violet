defmodule Commandline.CLI do
  def main(args) do
    options = [switches: [file: :string, unitTest: :string], aliases: [f: :file, ut: :unitTest]]
    {opts, _, _} = OptionParser.parse(args, options)

    read_file(opts[:unitTest])
  end

  def write_file(path, content) do
    js_generated_file = "#{Path.dirname(path)}/#{Path.basename(path, ".svelte")}.spec.js"
    File.touch(js_generated_file, System.os_time(:second))

    try do
      File.write(js_generated_file, content)

      {:ok,
       IO.puts("Arquivo #{Path.basename(path, ".svelte")}.spec.js salvo em #{Path.dirname(path)}")}
    catch
      :enoent -> {:error, "Diretório não encontrado."}
      :eacces -> {:error, "Permissão negada."}
      :eisdir -> {:error, "O caminho especificado é um diretório."}
      :eexist -> {:error, "Já existe um arquivo com este nome."}
      :badarg -> {:error, "Argumento inválido."}
    end
  end

  def get_content_file(path, content) do
    choice =
      content
      |> Map.get(:choices)
      |> hd()

    write_file(path, choice["text"])
  end

  def compile_svelte_file(path, file) do
    case(
      OpenAI.completions(
        model: "text-davinci-003",
        prompt:
          "create unit test in jest importing and using this svelte component called #{Path.basename(path)} #{file}",
        max_tokens: 2048,
        temperature: 0,
        n: 1,
        best_of: 1
      )
    ) do
      {:ok, content} ->
        IO.puts("Gravando arquivo de testes...")
        get_content_file(path, content)

      {:error, reason} ->
        {:error, "Failed to read file: #{reason}"}
    end
  end

  def read_file(path) do
    case File.read(path) do
      {:ok, content} ->
        IO.puts("Lendo arquivo no diretório...")
        compile_svelte_file(path, content)

      {:error, :enoent} ->
        {:error, "File not found: #{path}"}

      {:error, reason} ->
        {:error, "Failed to read file: #{reason}"}
    end
  end
end
