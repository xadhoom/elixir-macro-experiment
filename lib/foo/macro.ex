defmodule Foo.Macro do
  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :__definitions__, accumulate: false, persist: false)

      import Foo.Macro
    end
  end

  defmacro event(_name, do: block) do
    quote do
      """
      unquote(block)
      |> Enum.reduce("def parse(event), do: %{", fn {key, parser}, acc ->
        {m, f, args} = parser
        args = ["event" | args]
        ~s"#{acc} k: #{inspect(m)}.#{f}(#{Enum.join(args, ", ")}),"
      end)
      |> Kernel.<>("}")
      |> Code.string_to_quoted!()
      """

      def parse_map(event) do
        unquote(block)
        |> Enum.map(fn {key, parser} ->
          {m, f, args} = parser
          {key, apply(m, f, [event | args])}
        end)
        |> Map.new()
      end
    end
  end
end
