defmodule ExMon.Game.Actions.AttackTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  alias ExMon.Game.Actions.Attack

  describe "attack_opponent/2" do
    test "should perform an attack to the computer successfully" do
      player = Player.build("TestUser", :chute, :soco, :cura)
      computer = Player.build("Machine", :chute, :soco, :cura)

      Game.start(computer, player, :random)

      messages =
        capture_io(fn ->
          assert Attack.attack_opponent(:computer, :move_avg) == :ok
        end)

      assert messages =~ "===== The Player attacked the computer dealing"
    end
  end
end
