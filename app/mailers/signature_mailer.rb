class SignatureMailer < ApplicationMailer
  # all signatories get a mail that the hand over took place
  def handed_over_signatories_mail(signature)
    @signature = signature
    @petition = @signature.petition
    @unique_key = url_for(
      controller: 'signatures',
      action: 'confirm',
      signature_id: @signature.unique_key)

    subject = t('mail.handed_over_subject', petition: @petition.name)
    mail(to: signature.person_email, subject: subject)
  end

  # signatory gets the answer to the petition
  # rake petition:publish_answer_to_subscribers
  def inform_user_of_answer_mail(signature, petition, answer)
    @signature = signature
    @petition = petition
    @answer = answer
    @unique_key = url_for(
      controller: 'signatures',
      action: 'confirm',
      signature_id: @signature.unique_key)

    subject = t('mail.petition.has_answer_subject', petition: @petition.name)

    mail(to: signature.person_email, subject: subject)
  end

  # subscribed signatory gets a copy of news update with mail flag
  # rake petition:publish_news_to_subscribers
  def inform_user_of_news_update_mail(signature, petition, update)
    @signature = signature
    @update = update
    @petition = petition
    @unique_key = url_for(
      controller: 'signatures',
      action: 'confirm',
      signature_id: @signature.unique_key)

    subject = t('mail.petition.progress_subject', petition: @petition.name)

    mail(to: signature.person_email, subject: subject)
  end

  # users must confirm their signature
  # by following the confirm_url link in this email
  def sig_confirmation_mail(signature)
    @signature = signature

    @confirm_url = url_for(controller: 'signatures',
                           action: 'confirm',
                           signature_id: @signature.unique_key)

    # find the petition name
    name = 'noname'
    name = @signature.petition.name if @signature.petition.present?

    subject = t('mail.confirm.signature.subject', petition_name: name)

    mail(to: @signature.person_email, subject: subject)
  end

  def sig_reminder_confirm_mail(signature)
    @signature = signature
    @petition = @signature.petition

    @confirm_url = url_for(
      controller: 'signatures',
      action: 'confirm',
      signature_id: @signature.unique_key)

    name = @signature.petition.name if @signature.petition.present?

    subject = t('mail.confirm.signature.subject_reminder', petition_name: name)

    mail(to: @signature.person_email, subject: subject)
  end

  # send a default email informing recipient of petition
  def share_mail(signature, target_email)
    # build the required globals for the template
    @signature = signature
    @petition = @signature.petition
    @person_function = ''
    unless @signature.person_function.nil?
      @person_function = t('mail.mailafriend.note') + " \"#{@signature.person_function}\""
    end
    # build a catch subject line
    subject = t('mail.mailafriend.subject', title: @petition.name)

    mail(to: target_email, subject: subject)
  end

  def inform_user_of_news_mail(signature, petition, news_update)
    # TODO: for reinder
  end
end
