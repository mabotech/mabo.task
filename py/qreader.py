# -*- coding: utf-8 -*-


"""task server"""


import nsq

import ssl

import tornado.options


def handler(msg):
    """ msg handler"""
    
    print msg.body
    
    return True


def main():
    
    """main"""
    
    tornado.options.parse_command_line()
    
    reader = nsq.Reader(topic='test', channel='pynsq', 
                        nsqd_tcp_addresses=['127.0.0.1:4150'],
                        message_handler=handler, heartbeat_interval=10, 
                        tls_v1=True, tls_options={'cert_reqs': ssl.CERT_NONE},
                        snappy=True,
                        output_buffer_size=4096, output_buffer_timeout=100,
                        user_agent='test')
    
    nsq.run()
    
    
if __name__ == '__main__':
    main()