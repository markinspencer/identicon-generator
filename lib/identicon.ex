defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, filename) do 
    File.write("images/#{filename}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do 
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) -> 
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end 

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do 
    pixel_map = Enum.map(grid, &to_pixel/1)
    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def to_pixel({_code, index}) do 
    horizontal = rem(index, 5) * 50
    vertical = div(index, 5) * 50
    
    top_left = {horizontal, vertical}
    bottom_right = {horizontal + 50, vertical + 50}
    
    {top_left, bottom_right}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    updatedGrid = Enum.filter grid, fn({code, _index}) -> 
      rem(code, 2) == 0
    end
    %Identicon.Image{image | grid: updatedGrid}  
  end

  def build_grid(%Identicon.Image{seed: seed} = image) do 
    grid = 
      seed
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index
    
    %Identicon.Image{image | grid: grid}  
  end

  def mirror_row([first, second | _tail] = row ) do 
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{seed: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}  
  end

  def hash_input(input) do
    seed = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{seed: seed}
  end
end
