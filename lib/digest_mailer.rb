require 'active_support'

require File.dirname(__FILE__) + '/digest_mailer/mail_orchestrator'
require File.dirname(__FILE__) + '/digest_mailer/mail_delayed_job_scheduler'
require File.dirname(__FILE__) + '/digest_mailer/mail_dispatcher'
require File.dirname(__FILE__) + '/digest_mailer/mail_logger'
require File.dirname(__FILE__) + '/digest_mailer/layout/html_digest_layout'
require File.dirname(__FILE__) + '/digest_mailer/layout/text_digest_layout'

Dir[File.dirname(__FILE__)+"/../lib/digest_mailer/models/*.rb"].each {|file| require file }