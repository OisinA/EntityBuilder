require "../lib/hedron/src/hedron.cr"
require "json"

class EntityBuilder < Hedron::Application
  @window : Hedron::Window?

  def on_closing(this)
    this.destroy
    self.stop
    return false
  end

  def should_quit
    @window.not_nil!.destroy
    return true
  end

  def on_click(button)
    unless @name
      return
    end
    to_write = JSON.build do |json|
      json.object do
        json.field "name", @name.not_nil!.text
        json.field "health", @health.not_nil!.value
        json.field "mana", @mana.not_nil!.value
        json.field "speed", @speed.not_nil!.text.to_f
        json.field "behaviours", @behaviours.not_nil!.text.split "\n"
      end
    end
    File.write @name.not_nil!.text.downcase + ".json", to_write
    puts "Wrote to " + @name.not_nil!.text + ".json"
  end

  def draw
    self.on_stop = ->should_quit

    @window = Hedron::Window.new("Entity Builder", {640, 480}, menubar: true)
    @window.not_nil!.on_close = ->on_closing(Hedron::Window)
    @window.not_nil!.margined = true

    grid = Hedron::Grid.new
    grid.padded = true

    cell_info = Hedron::GridCell.new(
      size: {1, 1},
      expand: {false, false},
      align_x: :fill,
      align_y: :fill
    )

    cell_info1 = Hedron::GridCell.new(
      size: {1, 10},
      expand: {false, false},
      align_x: :fill,
      align_y: :fill
    )

    grid.push(Hedron::Label.new("Entity Name"), {1, 0}, cell_info)
    grid.push(Hedron::Label.new("Health"), {1, 2}, cell_info)
    grid.push(Hedron::Label.new("Mana"), {1, 4}, cell_info)
    grid.push(Hedron::Label.new("Speed"), {1, 6}, cell_info)
    grid.push(Hedron::Label.new("Behaviours"), {1, 8}, cell_info)

    @name = Hedron::Entry.new
    @name.not_nil!.text = "Slime"
    grid.push(@name.not_nil!, {2, 0}, cell_info)

    @health = Hedron::Slider.new({0, 100})
    @health.not_nil!.value = 50
    grid.push(@health.not_nil!, {2, 2}, cell_info)

    @mana = Hedron::Slider.new({0, 100})
    @mana.not_nil!.value = 50
    grid.push(@mana.not_nil!, {2, 4}, cell_info)

    @speed = Hedron::Entry.new
    @speed.not_nil!.text = "0.5"
    grid.push(@speed.not_nil!, {2, 6}, cell_info)

    @behaviours = Hedron::MultilineEntry.new
    @behaviours.not_nil!.stretchy = true
    grid.push(@behaviours.not_nil!, {2, 8}, cell_info1)

    create = Hedron::Button.new "Create"
    create.on_click = ->on_click(Hedron::Button)
    grid.push(create, {2, 18}, cell_info)

    @window.not_nil!.child = grid
    @window.not_nil!.show
  end
end

builder = EntityBuilder.new
builder.start
builder.close