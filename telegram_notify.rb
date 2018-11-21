# Content: Metasploit Module to send telegram notification if a session is opened
# Author: Ege Balcı| @egeblc | https://pentest.blog
# Date: 11/2018


require 'uri'
require 'net/http'
require 'msf/core'

class MetasploitModule < Msf::Post

    def initialize
        super(
        'Name' => 'Telegram Notification for opened session',
        'Version' => '1.0',
        'Description' => 'This Modul will notify you with a telegram message.',
        'Author' => 'Ege Balcı <ege.balci@invictuseurope.com>',
        'License' => MSF_LICENSE,
        'Platform' => 'multi')

		register_options(
			[
            	OptString.new('BOT_TOKEN', [true, 'Telegram BOT token', '']),
            	OptString.new('CHAT_ID', [true, 'Chat ID for the BOT', '']),
            	OptString.new('MSG', [true, 'Notify message', 'New session opened !'])

        	], self.class
    	)
    end

    def run
        begin
            #
            # We have to use Net::HTTP instead of HttpClient because of the following error:
            # The supplied module name is ambiguous: undefined method `register_autofilter_ports'
            #
            url = URI('https://api.telegram.org/bot'+datastore['BOT_TOKEN']+'/sendMessage?chat_id='+datastore['CHAT_ID']+'&parse_mode=Markdown&text='+datastore['MSG'])
            res = Net::HTTP.get_response(url)
            if res.is_a?(Net::HTTPSuccess)
                print_good('Notification sent')
            else
                print_error('Unable to send the notification')
            end
        end
    end
end

