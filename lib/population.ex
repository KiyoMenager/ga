defmodule Ga.Population do

  @default_height 10
  @default_width 10

  @type t :: ToroidalGrid.t
  @type individual :: ToroidalGrid.element

  @doc ~S"""
  Returns a toroidalgrid of size `rows`X`cols` where each item is the result
  of invoking `fun`, passing the row number and column number as arguments.

  ## Examples
      iex> genes = {"a", "b", "c", "d"}
      iex> Ga.Population.new(genes)
      iex> true
      true
  """
  @spec new(tuple()) :: t

  def new(genes) do
    config = Application.get_env(:ga, __MODULE__, [])
    h = config[:height] || @default_height
    w = config[:width] || @default_width
    population = ToroidalGrid.new(h, w, generator(genes |> Tuple.to_list))
  end

  # Returns a generator to generate random `individuals` from the given genes.
  @spec generator(list()) :: TupleMatrix.producer

  defp generator(genes) do
    fn _i, _j ->
      genes |> Enum.shuffle
    end
  end
end
