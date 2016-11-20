defmodule Ga.Individual do
  @moduledoc """
  A module defining an `Individual`. An individual is a candidate solution.
  For performances reason, individual fitness is calculated at its creation.
  """

  @opaque t :: %__MODULE__{genes: list, fitness: Float.t}
  defstruct [:genes, :fitness]



  @doc """
  Returns a new `individual` passing `genes` (its encoded genome representation)
  and a `criterion_callback` responsible of calculating the cost of the
  representation according to the criterion to maximize(or minimize).

    ##Examples

      iex> criterion_callback = fn genes, _ -> genes |> Enum.reduce(&(&1 + &2)) end
      iex> Ga.Individual.new([3, 7, 6, 4], criterion_callback)
      %Ga.Individual{genes: [3, 7, 6, 4], fitness: 0.05}

      if no `criterion_callback` is given, fitness is set to max which is 1.0.

      iex> Ga.Individual.new([3, 7, 6, 4])
      %Ga.Individual{genes: [3, 7, 6, 4], fitness: 1.0}
  """
  @spec new(list, (list -> Float.t)) :: list

  def new(genes, criterion_callback \\ nil) do
    criterion = if criterion_callback, do: criterion_callback.(genes, :cyclic), else: 1
    %__MODULE__{genes: genes, fitness: 1 / criterion}
  end

  @doc """
  Returns the genetical representation of the individual.
  ##Examples
    iex> [3, 7, 6, 4]
    ...> |> Ga.Individual.new(fn _, _ -> 1 end)
    ...> |> Ga.Individual.genes
    [3, 7, 6, 4]

  """
  @spec genes(t) :: list

  def genes(%__MODULE__{genes: genes}), do: genes

  @doc """
  Returns the fittest `individual`.

    ##Examples
      iex> unfit_ind = [] |> Ga.Individual.new(fn _, _ -> 20 end)
      iex> fit_ind = [] |> Ga.Individual.new(fn _, _ -> 1 end)
      iex> fittest = Ga.Individual.fittest(fit_ind, unfit_ind)
      iex> fit_ind == fittest
      true

  """
  @spec fittest(t, t) :: t

  def fittest(%__MODULE__{fitness: fst_fitness} = fst,
             %__MODULE__{fitness: sec_fitness} = sec) do
    if fst_fitness > sec_fitness, do: fst, else: sec
  end

end
