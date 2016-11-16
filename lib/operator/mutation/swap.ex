defmodule Ga.Operator.Mutation.Swap do
  @behaviour Ga.Operator

  @doc """
  Implements the Ga.Operator behaviour.

  """
  @spec get_callback() :: Ga.Operator.callback
  
	def get_callback(_opts \\ []), do: &call/3

	@doc """
  Swaps two nodes of the `genome`. Node located at `fst_pos` with node
  located at `sec_pos`.
	If `fst_pos` and `sec_pos` are out of bounds, the given list is returned.

	## Examples

			iex> alias Ga.Operator.Mutation.Swap
			iex> genome = ["a", "b", "c", "d", "e"]
			iex> Swap.call(genome, 0, 4)
			["e", "b", "c", "d", "a"]
			iex> Swap.call(genome, 0, 0)
			["a", "b", "c", "d", "e"]
			iex> Swap.call(genome, 0, 5)
			["a", "b", "c", "d", "e"]
			iex> Swap.call(genome, -1, 3)
			["a", "b", "c", "d", "e"]

	"""
  @spec call(list(), non_neg_integer, non_neg_integer) :: list()

	def call(genome,     pos,       _) when pos >= length(genome), do: genome
	def call(genome,       _,     pos) when pos >= length(genome), do: genome
	def call(genome,     pos,       _) when pos < 0, do: genome
	def call(genome,       _,     pos) when pos < 0, do: genome
	def call(genome,     pos,     pos), do: genome
	def call(genome, fst_pos, sec_pos) do
		fst_gene = genome |> Enum.at(fst_pos)
		sec_gene = genome |> Enum.at(sec_pos)
		genome
		|> List.replace_at(fst_pos, sec_gene)
		|> List.replace_at(sec_pos, fst_gene)
	end
end
