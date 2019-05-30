# TODO: This script will process all repos a user has access to and migrate them to the
# new server without consideration for any organization repos that user has access to.
# Need to figure out how to transfer organization repos to an organization of the same
# name so you to dont have manually transfer repos afterwards to correct organizations.

from pprint import pprint as pp
import requests as rq

new_api_key = '8b9a9140a3482d61a1681bf5ec0a5ddeda6306cc'

url_new_user_api = f'https://gojira2.fr.local/api/v1/user?access_token={new_api_key}'

print('Fetching user id from new api')
user_id = rq.get(url_new_user_api).json()['id']
print(f'User id is {user_id}')

old_api_key = 'd8f21b898cf31b24edc01a1b8e5151fdab7a7126'
url_old_repos = f'https://gojira.fr.local/api/v1/user/repos?access_token={old_api_key}'

url_new_migrate_api = f'https://gojira2.fr.local/api/v1/repos/migrate?access_token={new_api_key}'

print('Getting list of old repos')
old_repos = rq.get(url_old_repos).json()

for repo in old_repos:
    print(f'Processing: {repo["name"]}')
    j = {
            'clone_addr': repo['clone_url'].replace('https://gojira.local', 'http://192.168.1.112:3000'),
        'description': repo['description'],
        'mirror': False,
        'private': repo['private'],
        'repo_name': repo['name'],
        'uid': user_id,
    }
    pp(j)
    resp = rq.post(url_new_migrate_api, data=j)
    print(resp.status_code)
    pp(resp.json())
    print()
