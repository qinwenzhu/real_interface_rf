ROBOT_LISTENER_API_VERSION = 2

def log_message(message):
    print(message['timestamp'] + ":\t" + message['level'] + ":\t" + message['message'])
