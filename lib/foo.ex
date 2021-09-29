defmodule Foo do
  use Foo.Macro

  event :something do
    %{
      foo: {Map, :get, [:somekey]},
      bar: {Map, :get, [:someotherkey]}
    }
  end
end
