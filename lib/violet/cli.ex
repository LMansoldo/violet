defmodule Commandline.CLI do
  def main(args) do
    options = [switches: [file: :string, unitTest: :string], aliases: [f: :file, ut: :unitTest]]
    {opts, _, _} = OptionParser.parse(args, options)

    read_file(opts[:unitTest])
  end

  def read_file(path) do
    case File.read(path) do
      {:ok, content} ->
        IO.puts("Lendo arquivo no diretório...")
        compile_svelte_file(path, content)
      {:error, reason} ->
        IO.puts("Erro ao ler o arquivo: #{reason}")
        ""
    end
  end

  def write_file(path, content) do
    js_filename = "#{Path.basename(path, ".svelte")}.spec.js"
    js_dirname = Path.dirname(path)

    try do File.write("#{js_dirname}/#{js_filename}", content)
      {:ok, IO.puts("Arquivo #{js_filename} salvo em #{path}")}
    catch
      :enoent -> {:error, "Diretório não encontrado."}
      :eacces -> {:error, "Permissão negada."}
      :eisdir -> {:error, "O caminho especificado é um diretório."}
      :eexist -> {:error, "Já existe um arquivo com este nome."}
      :badarg -> {:error, "Argumento inválido."}
    end

  end

  def compile_svelte_file(path, file) do
    {:ok, response} =
      OpenAI.completions(
        model: "text-davinci-003",
        prompt: "create unit test in jest #{file}",
        max_tokens: 2048,
        temperature: 0.1
      )

    text =
      response
      |> Map.get(:choices)
      |> hd()


      write_file(path, text["text"])
    response
  end
end
