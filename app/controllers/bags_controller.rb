# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.


class BagsController < ApplicationController
  include Authenticate
  include Pagination
  include Adaptation

  local_node_only :create, :update, :destroy
  uses_pagination :index
  adapt!

  def index
    @bags = Bag.updated_after(params[:after])
      .updated_before(params[:before])
      .with_admin_node_id(params[:admin_node_id])
      .with_member_id(params[:member_id])
      .with_bag_type(params[:type])
      .order(parse_ordering(params[:order_by]))
      .page(@page)
      .per(@page_size)

    render "shared/index", status: 200
  end


  def show
    @bag = Bag.find_by_uuid!(params[:uuid])
    render "shared/show", status: 200
  end


  def create
    if Bag.find_by_uuid(params[:uuid]).present?
      render nothing: true, status: 409 and return
    else
      @bag = Bag.new(create_params)
      @bag.replicating_nodes = params[:replicating_nodes]
      @bag.version_family = params[:version_family]
      @bag.fixity_checks = params[:fixity_checks]
      if @bag.type == DataBag.to_s
        @bag.rights_bags = params[:rights_bags]
        @bag.interpretive_bags = params[:interpretive_bags]
      end
      if @bag.save
        render "shared/create", status: 201
      else
        render "shared/errors", status: 400
      end
    end
  end


  def update
    @bag = Bag.find_by_uuid!(params[:uuid])

    update_bag(@bag)
    unless @bag.save
      render "shared/errors", status: 400 and return
    end

    render "shared/update", status: 200
  end


  def destroy
    bag = Bag.find_by_uuid!(params[:uuid])
    bag.destroy!
    render nothing: true, status: 204
  end


  private
  def create_params
    params.permit(Bag.attribute_names)
  end

  def update_params
    params.permit(
      :uuid, :local_id, :size, 
      :version, :version_family_id,
      :ingest_node_id, :admin_node_id,
      :type, :member_id
    )
  end

  def update_bag(bag)
    bag.attributes = update_params
    bag.replicating_nodes = params[:replicating_nodes]
    bag.version_family = params[:version_family]
    bag.fixity_checks = params[:fixity_checks]
    if bag.type == DataBag.to_s
      bag.rights_bags = params[:rights_bags]
      bag.interpretive_bags = params[:interpretive_bags]
    end
    return bag
  end

end
