defmodule Ga.Population do

  alias Ga.{Config, Individual}

  @opaque t :: %__MODULE__{individuals: ToroidalGrid.t, step: step}
  defstruct [:individuals, :step]

  @type   config     :: Config.t
  @type   step       :: non_neg_integer
  @type   individual :: Individual.t

  @spec new(tuple(), config) :: t

  def new(genes, config) do
    individuals = ToroidalGrid.new(10, 10, generator_callback(genes, config))
    %__MODULE__{individuals: individuals, step: 0}
  end

  @doc """
  Evolves the given `population` to step + 1 with the given `config`.
  """
  @spec steps_up(t, config) :: t

  def steps_up(%__MODULE__{individuals: inds, step: step} = population, config) do
    inds = inds |> ToroidalGrid.map_neighborhoods(&steps_up(&1, &2, config, step))
    %__MODULE__{population | individuals: inds, step: step + 1}
  end

  @doc """
  Evolves the given `subject` individual in its neighborhood with the given
  `config`.
  """
  @spec steps_up(individual, list(individual), config, step) :: t

  def steps_up(subject, neighbors, config, step) do
    neighbors
    |> do_tournament(config)
    |> do_crossover(subject, config)
    |> do_mutation(config)
    |> do_local_opt(config, step)
    |> insert_if_better(subject, config)
  end

  @spec do_tournament(list(individual), config) :: t
  def do_tournament(neighborhood, _config) do
    neighborhood
    |> Enum.take_random(2)
    |> Enum.reduce(&Individual.fittest(&1, &2))
  end

  @doc """
  Applies a recombination operator between two individuals.

      iex> fst_ind = Ga.Individual.new(["a", "b", "c"])
      iex> sec_ind = Ga.Individual.new(["a", "b", "c"])
      iex> config = Ga.Config.new(crossovers: [Ga.Operator.Erx])
      iex> offspring = Ga.Population.do_crossover(fst_ind, sec_ind, config)
      iex> length(offspring)
      3

  """
  @spec do_crossover(individual, individual, config) :: t

  def do_crossover(fst_ind, sec_ind, config) do
    case config |> Config.operator_for(:crossover) do
      {:ok, op} -> op.([Individual.genes(fst_ind), Individual.genes(sec_ind)])
      :not_found -> Individual.genes(fst_ind)
    end
  end

  @doc """
  Applies a mutation operator on an ordered list of genes.

      iex> Ga.Population.do_mutation(["a", "b", "c"], Ga.Config.new)
      ["a", "b", "c"]

  """
  @spec do_mutation(list, config) :: t

  def do_mutation(genes, config) do
    case config |> Config.operator_for(:mutation) do
      {:ok, op}  -> op.(genes)
      :not_found -> genes
    end
  end

  @doc """
  Applies a local optimisation operator on an ordered list of genes.

      iex> Ga.Population.do_local_opt(["a", "b", "c"], Ga.Config.new, :infinity)
      ["a", "b", "c"]

  """
  @spec do_local_opt(list, config, step) :: t
  def do_local_opt(genes, config, step) do
    case config |> Config.optimisation_for(:local_opt, step) do
      {:ok, op}  -> op.(genes)
      :not_found -> genes
    end
  end

  @doc """
  Applies a local optimisation operator on an ordered list of genes.
  """
  @spec insert_if_better(list, individual, config) :: t

  def insert_if_better(genes, indiv, config) do
    case config |> Config.callback_for(:criterion) do
      {:ok, callback} -> Individual.new(genes, callback) |> Individual.fittest(indiv)
      :not_found      -> indiv
    end
  end

  @doc """
  Returns the fittest `individual` in the given `population`.

  """
  @spec fittest(t) :: Individual.t

  def fittest(%__MODULE__{individuals: individuals}) do
    individuals |> ToroidalGrid.reduce(&Individual.fittest(&1, &2))
  end

  # Returns a generator to generate random `individuals` from the given genes.
  @spec generator_callback(list(), config) :: TupleMatrix.producer

  defp generator_callback([gene|genes], config) do
    fn _i, _j ->
      genome = [gene | (genes |> Enum.shuffle)]
      Individual.new(genome, config.criterion_callback)
    end
  end
end
