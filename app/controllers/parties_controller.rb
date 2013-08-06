class PartiesController < ApplicationController
  def index
    @parties = Party.user(current_user, PartyRole.read_only).all

    respond_to do |format|
      format.html
      format.json { render json: @parties }
    end
  end

  def show
    @party = Party.user(current_user, PartyRole.read_only).find(params[:id])
    @messages = @party.messages.order(:date)

    respond_to do |format|
      format.html
      format.json { render json: @party }
    end
  end

  # GET /email_accounts/new
  # GET /email_accounts/new.json
  def new
    @email_account = EmailAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @email_account }
    end
  end

  # GET /email_accounts/1/edit
  def edit
    @email_account = EmailAccount.user(current_user).find(params[:id])
  end

  # POST /email_accounts
  # POST /email_accounts.json
  def create
    @email_account = EmailAccount.new(params[:email_account])
    @email_account.user_id = current_user.id

    respond_to do |format|
      if @email_account.save
        format.html { redirect_to @email_account, notice: 'Email account was successfully created.' }
        format.json { render json: @email_account, status: :created, location: @email_account }
      else
        format.html { render action: "new" }
        format.json { render json: @email_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /email_accounts/1
  # PUT /email_accounts/1.json
  def update
    @email_account = EmailAccount.user(current_user).find(params[:id])

    respond_to do |format|
      if @email_account.update_attributes(params[:email_account])
        format.html { redirect_to @email_account, notice: 'Email account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @email_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_accounts/1
  # DELETE /email_accounts/1.json
  def destroy
    @email_account = EmailAccount.user(current_user).find(params[:id])
    @email_account.destroy

    respond_to do |format|
      format.html { redirect_to email_accounts_url }
      format.json { head :no_content }
    end
  end
end
