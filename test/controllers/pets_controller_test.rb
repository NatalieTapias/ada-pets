require 'test_helper'

describe PetsController do
  let(:pet_fields) { ["age", "human", "id", "name"] }

  describe "index" do
    it "responds with JSON and success" do
      get pets_path

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end
    
    it "responds with an array of pet hashes" do
      # Act
      get pets_path
  
      # Get the body of the response
      body = JSON.parse(response.body)
  
      # Assert
      expect(body).must_be_instance_of Array
      body.each do |pet|
        expect(pet).must_be_instance_of Hash
        expect(pet.keys.sort).must_equal pet_fields
      end
    end

    it "should respond with an empty array if there are no pets" do
      Pet.destroy_all

      get pets_path
      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Array
      expect(body).must_be_empty
      expect(body).must_equal []
    end
  end

  describe "show" do
    it "should respond with JSON and success when looking for a valid pet" do
      pet = pets(:one)
      get pet_path(pet)
      body = JSON.parse(response.body)

      expect(response.header['Content-Type']).must_include 'json'
      expect(body).must_be_instance_of Hash
      must_respond_with :success
      expect(body["name"]).must_equal "Peanut"
    end

    it "should respond with a pet hash & must respond with pet_fields" do
      # Act
      get pet_path(Pet.first)

      # Get the body of the response
      body = JSON.parse(response.body)
  
      # Assert
      expect(body).must_be_instance_of Hash
      expect(body.keys.sort).must_equal pet_fields
    end

    it "should respond with 204 :no content with an invalid id" do
      get pet_path(-1)
      body = JSON.parse(response.body)

      expect(response.header['Content-Type']).must_include 'json'
      expect(body.keys).must_equal ["errors"]
      must_respond_with :not_found
    end

    it "should respond with 204 :no content when looking up a deleted pet" do
      pet = pets(:one)
      pet.destroy

      get pet_path(pet)
      body = JSON.parse(response.body)

      expect(response.header['Content-Type']).must_include 'json'
      expect(body.keys).must_equal ["errors"]
      must_respond_with :not_found
    end
  end
end
