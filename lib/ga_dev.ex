require Logger
defmodule GaDev do

  alias Ga.PopulationDev, as: Population
  alias Ga.{Config, Individual}

  @type fitness_calculator :: ((permutation) -> fitness)
  @type fitness            :: float
  @type config             :: Config.t
  @type permutation        :: tuple
  @type population         :: PopulationDev.t

  @doc """
  Runs the genetical algorithm on the given `permutation` tuned with `config`.

  """
  @spec run(permutation, config) :: permutation

  def run(permutation, config) do
    Population.new(permutation, config) |> ga(config)
  end

  @doc """
  The Recursive genetical algorithm that stops when the stop condition given in
  `config` is met.

  """
  def ga(population, config) do
    do_ga(try_stop_condition(population, config))
  end

  def do_ga({:done, population, config}), do: {:done, population, config}
  def do_ga({:cont, population, config}) do
    population
    |> Population.steps_up(config)
    |> try_stop_condition(config)
    |> do_ga
  end

  @doc """
  Returns a tagged tuple telling if the algorithms should continue or stop for
  the current step and prints it.

  """
  @spec try_stop_condition(population, config) :: {:done, population, config}
                                                | {:cont, population, config}

  def try_stop_condition(population, config) do
    population
    |> report(config)
    |> stop(config)
  end

  @doc """
  Prints information about the state of the solution at given step.
  
  """
  def report(%Population{step: step} = population, %Config{criterion_callback: callback}) do
    fittest_genome =
      population
      |> Population.fittest
      |> Individual.genes

    distance = callback.(fittest_genome)

    Logger.warn inspect "Generation: #{step}, distance : #{distance}"
    Logger.warn inspect fittest_genome

    population
  end

  def stop(%Population{step: stop} = population, %Config{stop_generation: stop} = config) do
    {:done, population, config}
  end
  def stop(population, config) do
    {:cont, population, config}
  end
end
