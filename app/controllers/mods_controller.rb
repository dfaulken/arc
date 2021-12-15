class ModsController < ApplicationController
  before_action :authenticate_mod!
  before_action :set_mod, only: %i[ approve destroy ]

  def approve
    @mod.update approved: true
    redirect_to mods_path, notice: 'Mod has been approved.'
  end

  def destroy
    @mod.destroy
    redirect_to mods_path, notice: 'Mod has been deleted.'
  end

  def index
    @mods = Mod.all
  end

  private

  def set_mod
    @mod = Mod.find(params.require(:id))
  end
end
