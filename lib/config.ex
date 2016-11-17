defmodule Ga.Config do

  alias Ga.Operator
  alias Ga.Operator.{Recombination, Mutation, LocalOptimisation}

  @opaque t :: %__MODULE__{
    distance_callback:  (... -> any),
    criterion_callback: (... -> any),
    crossovers:         list,
    mutations:          list,
    local_opts:         list,
    opt_start:          Integer.t,
    stop_generation:    Integer.t
  }
  defstruct distance_callback:  nil,
            criterion_callback: nil,
            crossovers:         [],
            mutations:          [],
            local_opts:         [],
            opt_start:          :infinity,
            stop_generation:    100

  @type operator_callback :: Operator.callback

  @doc """
  Returns a new configuration.
  `criterion_callback` is the function that calculates an individual weight.
  `crossovers` is a list of recombination algorithms.
  `mutations` is a list of mutation algorithms.
  `local_opts` is a list of local optimisation algorithms.

  ## Examples
      iex> Ga.Config.new(crossovers: [Ga.Operator.Erx])
      %Ga.Config{
        criterion_callback: nil,
        crossovers:         [Ga.Operator.Erx],
        mutations:          [],
        local_opts:         []
      }
  """
  @spec new() :: t
  @spec new(list) :: t

  def new(opts \\ []) do
    %__MODULE__{
      distance_callback:  Keyword.get(opts, :distance_callback),
      criterion_callback: Keyword.get(opts, :criterion_callback),
      crossovers:         Keyword.get(opts, :crossovers, []),
      mutations:          Keyword.get(opts, :mutations, []),
      local_opts:         Keyword.get(opts, :local_opts, []),
      opt_start:          Keyword.get(opts, :opt_start, :infinity),
      stop_generation:    Keyword.get(opts, :stop_generation, 100)
    }
  end

  @doc """
  Returns an operator according to the given tag.

  """
  @spec operator_for(t, atom) :: operator_callback

  def operator_for(%__MODULE__{crossovers: modules}, :crossover) do
    handle_initialization(Recombination.get_callback(modules: modules))
  end
  def operator_for(%__MODULE__{mutations: modules}, :mutation) do
    handle_initialization(Mutation.get_callback(modules: modules, rate: 0.015))
  end

  def optimisation_for(%__MODULE__{}, :local_opt, :infinity), do: handle_initialization(nil)
  def optimisation_for(%__MODULE__{}, :local_opt,         0), do: handle_initialization(nil)
  def optimisation_for(%__MODULE__{local_opts: modules, distance_callback: callback, opt_start: start}, :local_opt, step) do
    cond do
      rem(step, start) == 0 ->
        handle_initialization(LocalOptimisation.get_callback(modules: modules, distance_callback: callback))
      :else -> handle_initialization(nil)
    end

  end

  @doc """
  Returns a callback according to the given tag.

  """
  @spec callback_for(t, atom) :: operator_callback

  def callback_for(%__MODULE__{criterion_callback: callback}, :criterion) do
    handle_initialization(callback)
  end

  def callback_for(%__MODULE__{distance_callback: callback}, :distance) do
    handle_initialization(callback)
  end

  defp handle_initialization(nil), do: :not_found
  defp handle_initialization(operator), do: {:ok, operator}
end
