require 'rails_helper'

describe Node do
  context "local_node" do
    it "has a valid factory" do
      expect(Fabricate(:local_node)).to be_valid
    end

    it "has the same auth_credential and private_auth_token" do
      node = Fabricate(:local_node)
      expect(node.send(:generate_hash, node.auth_credential)).to eql(node.private_auth_token)
    end
  end

  it "has a valid factory" do
    expect(Fabricate(:node)).to be_valid
  end

  it "has a storage region" do
    node = Fabricate.build(:node)
    storage_region = node.storage_region

    expect(storage_region).to_not be_nil
  end

  it "has a storage type" do
    node = Fabricate.build(:node)
    storage_type = node.storage_type

    expect(storage_type).to_not be_nil
  end

  it "is invalid without a namespace" do
    expect {
      Fabricate(:node, namespace: nil)
    }.to raise_error
  end

  it "stores namespace as lowercase" do
    namespace = "saDFjDF"
    Fabricate(:node, namespace: namespace)

    instance = Node.where(namespace: namespace.downcase).first

    expect(instance).to be_valid
    expect(instance.namespace).to eql(namespace.downcase)
  end

  it "can be found when we search with uppercase" do
    namespace = "somenamespace"
    Fabricate(:node, namespace: namespace)

    instance = Node.find_by_namespace(namespace.upcase)

    expect(instance).to be_valid
  end

  it "can be found with find_by_namespace!!" do
    node = Fabricate(:node)
    expect{
      Node.find_by_namespace!(node.namespace)
    }.to_not raise_error
  end

  it "can Fabricate two nodes" do
    a = Fabricate(:node, namespace: "a")
    b = Fabricate(:node, namespace: "b")
    expect(a).to be_valid
    expect(b).to be_valid
  end

  it "is invalid without a name" do
    expect {
      Fabricate(:node, name: nil)
    }.to raise_error
  end

  it "can be saved" do
    node = Fabricate.build(:node)
    expect {
      expect(node.save).to be true
    }.to_not raise_error
  end

  it "receives replicate_to assignments" do
    node = Fabricate(:node)
    other_node = Fabricate(:node)
    node.replicate_to_nodes << other_node
    expect(node.save).to be true
  end

  it "encrypts the auth_credential" do
    cred = "thisisanauthcred"
    node = Fabricate(:node)
    node.auth_credential = cred
    node.save!
    expect(Node.find_by_auth_credential(Rails.configuration.cipher.encrypt(cred))).to_not be_nil
  end

  it "decrypts the auth_credential" do
    cred = "thisisanauthcred"
    node = Fabricate(:node)
    node.auth_credential = cred
    node.save!
    expect(node.reload.auth_credential).to eql(cred)
  end
end