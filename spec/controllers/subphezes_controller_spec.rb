require 'rails_helper'

describe SubphezesController do
  it 'redirects to random subphez for GET #random' do
    valid_pathname = /[a-zA-Z0-9]+/
    get :random
    expect(response).to redirect_to %r(\Ahttp://test.host/p/#{valid_pathname}\Z)
  end
end
