# Cap'n's Log

## Day 2

Today, after having done some initial design work, I decided to fire up some Elixir and see what a game model might look like. The _model_, in this case, is an in-memory representation of a **frontier**, the unit of player state within the game.

What's unique about a frontier is that when one is created, it gets some initialization over and above default values. For example, the terrain tiles get set to appropriate values, resources get distributed across the map, the player's storage silo gets planted in the middle of the map, and so on.

### Building an Elixir API for a Frontier

The first thing I do when building a model is start with the `defstruct`, which is what I did here:

```elixir
defmodule FrontiersSite.Model.Frontier do
  @max_rows 30
  @max_cols 30
  @length @max_rows * @max_cols - 1
  @resource_allocations [mines: 5, dairy: 7, wood: 20]

  alias FrontiersSite.Model.Frontier

  defstruct terrain: [], resources: [], public_key: "YEET"
end
```

I've made a few guesses as to the kinds of things I might need. I've decided that my grid is going to be **30x30**  (recall that in my video I said _50x50), but this value shoudl be easy enough to change. 

I've also decided that across all **900** grid squares on a given frontier, there will be **5** mines, **7** dairy farms, and **20** forests capable of yielding wood. 

I'm thinking of the frontier in terms of layers. At the bottom layer we have the terrain, which is basically going to be an indicator of the type of terrain texture/image used when rendering that portion of the map online.

Above the terrain layer is the _resources_ layer, which will be a list of resources and their corresponding locations. Something I'm sure I'm going to need but don't really have a good explanation for yet is the **public key** -- so just trust me that we'll want to put this on each frontier we create.

### Creating a Frontier

I like to build models like this in Elixir using _pipelines_ which pump a token (in this case, our frontier struct) through a chain of transformations. This usually means the first thing in the pipeline is the _empty_ version of that token. So what does an empty frontier look like?

```elixir
def empty(pk) do
  ter = for _idx <- 0..@length, do: :grass

  %Frontier{
    terrain: ter,
    public_key: pk
  }
end
```

You can see that, at least for today, we're filling all the tiles with grass. Once I get a decent game loop up and running, I'll come back and tweak the terrain icons and the rules for generation - I'd like to come up with some cool algorithms for procedurally generated frontiers but that'll wait for another cap'n's log entry.

Let's take a look at what I want the pipeline to look like for creating a frontier:

```elixir
 def new(pk) do
    empty(pk)
    |> place_silo
    |> place_wood_resources()
    |> place_dairy_resources()
    |> place_mines()
  end
```
The high-level pipeline here makes it pretty obvious what we're doing. We're starting with a new, empty frontier and then adding the player's storage silo, wood resources, dairy resources, and mines.

For the curious, here's the rest of the code that creates this pipeline:

```elixir
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
```

Now we can fire up `iex` and create a new frontier and see if we like what we've got (this was run against a 10x10 grid to make the output a little easier to read):

```elixir
ex(1)> f = FrontiersSite.Model.Frontier.new("Mxxx")
%FrontiersSite.Model.Frontier{
  public_key: "Mxxx",
  resources: [
    {{2, 4}, :wood},
    {{2, 1}, :wood},
    {{9, 3}, :wood},
    {{1, 0}, :wood},
    {{0, 9}, :wood},
    {{2, 2}, :wood},
    {{5, 2}, :wood},
    {{5, 2}, :wood},
    {{3, 7}, :wood},
    {{3, 1}, :wood},
    {{3, 7}, :wood},
    {{7, 0}, :wood},
    {{8, 1}, :wood},
    {{4, 3}, :wood},
    {{8, 8}, :wood},
    {{1, 1}, :wood},
    {{9, 9}, :wood}, 
    {{9, 9}, :wood},
    {{8, 9}, :wood},
    {{3, 0}, :wood},
    {{1, 2}, :dairy},
    {{5, 8}, :dairy},
    {{6, 0}, :dairy},
    {{0, 5}, :dairy},
    {{5, 2}, :dairy},
    {{3, 6}, :dairy},
    {{2, 7}, :dairy},
    {{2, 7}, :mine},
    {{0, 6}, :mine},
    {{6, 5}, :mine},
    {{9, 1}, :mine},
    {{4, 4}, :mine}
  ],
  terrain: [:grass, :grass, :grass, :grass, :grass, :grass, :grass, :grass,
   :grass, :grass, :grass, :grass, :grass, :grass, :grass, :grass, :grass,
   :grass, :grass, :grass, :grass, :grass, :grass, :grass, :grass, :grass,
   :grass, :grass, :grass, :grass, :grass, :grass, :grass, :grass, :grass,
   :grass, :grass, :grass, :grass, :grass, :grass, :grass, :grass, :grass,
   :grass, :grass, :grass, ...]
}
```

This looks like a pretty good start. We've got our base terrain (grass), we've got wood, dairy, and mine resources allocated randomly across the map. It looks like we're ready to see if we can make a renderer for this model, which I'll show in the next journal entry.

Hope you're enjoying following along during this journey. Please let me know on Twitter (@KevinHoffman) if there are things you'd like to read/see more or less of in these entries.

p.s. I didn't record this one because I still lack some decent audio recording equipment and so until then, I settled for doing this blog entry. Hopefully this is the last one that I do that doesn't come with an accompanying video.