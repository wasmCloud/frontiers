defmodule FrontiersSite.Model.Frontier do
  @max_rows 10
  @max_cols 10
  @length @max_rows * @max_cols - 1
  @resource_allocations [mines: 5, dairy: 7, wood: 20]

  alias FrontiersSite.Model.Frontier

  defstruct terrain: [], resources: [], public_key: "YEET"

  def empty(pk) do
    ter = for _idx <- 0..@length, do: :grass

    %Frontier{
      terrain: ter,
      public_key: pk
    }
  end

  def new(pk) do
    empty(pk)
    |> place_silo
    |> place_wood_resources()
    |> place_dairy_resources()
    |> place_mines()
  end

  defp place_wood_resources(f = %Frontier{}) do
    %Frontier{
      f
      | resources:
          1..@resource_allocations[:wood]
          |> Enum.map(fn _ ->
            {random_position(), :wood}
          end)
    }
  end

  defp place_dairy_resources(f = %Frontier{}) do
    %Frontier{
      f
      | resources:
          f.resources ++
            (1..@resource_allocations[:dairy]
             |> Enum.map(fn _ ->
               {random_position(), :dairy}
             end))
    }
  end

  defp place_mines(f = %Frontier{}) do
    %Frontier{
      f
      | resources:
          f.resources ++
            (1..@resource_allocations[:mines]
             |> Enum.map(fn _ ->
               {random_position(), :mine}
             end))
    }
  end

  defp place_silo(f = %Frontier{}) do
    %Frontier {
      f | terrain: List.replace_at(
        f.terrain,
        center()
        |> index(),
        :silo
      )
    }
  end

  defp random_position do
    {(:rand.uniform() * @max_rows) |> trunc(), (:rand.uniform() * @max_cols) |> trunc()}
  end

  defp index({row, col}) do
    row * @max_rows + col
  end

  defp center() do
    {div(@max_rows, 2), div(@max_cols, 2)}
  end
end
