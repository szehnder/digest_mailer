require 'active_support'

require File.dirname(__FILE__) + '/digest_mailer/mail_orchestrator'
require File.dirname(__FILE__) + '/digest_mailer/mail_delayed_job_scheduler'
require File.dirname(__FILE__) + '/digest_mailer/mail_dispatcher'
require File.dirname(__FILE__) + '/digest_mailer/mail_logger'
require File.dirname(__FILE__) + '/digest_mailer/layout/html_digest_layout'
require File.dirname(__FILE__) + '/digest_mailer/layout/text_digest_layout'
autoload :EmailDigest, File.dirname(__FILE__) + '/digest_mailer/models/email_digest'
autoload :EmailMessage, File.dirname(__FILE__) + '/digest_mailer/models/email_message'
require File.dirname(__FILE__) + '/digest_mailer/models/email_log'
require File.dirname(__FILE__) + '/digest_mailer/models/digest_type'
require File.dirname(__FILE__) + '/digest_mailer/models/pending_message'

#Dir[File.dirname(__FILE__)+"/digest_mailer/models/*.rb"].each {|file| require file }