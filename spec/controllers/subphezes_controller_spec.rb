require 'rails_helper'

describe SubphezesController, 'GET #random' do
  it 'redirects' do
    valid_pathname = /[a-zA-Z0-9]+/
    get :random
    puts response.inspect
    expect(response).to redirect_to %r(\Ahttp://test.host/p/#{valid_pathname}\Z)
  end
end
