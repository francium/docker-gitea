# TODO: This script will process all repos a user has access to and migrate them to the
# new server without consideration for any organization repos that user has access to.
# Need to figure out how to transfer organization repos to an organization of the same
# name so you to dont have manually transfer repos afterwards to correct organizations.

from pprint import pprint as pp
import requests as rq

NEW_SERVER_API_KEY = 'XXXXXXXXXXXXXXX'
NEW_SERVER_URL = 'https://XXXXXXXXXXX'
NEW_SERVER_USER_API_URL = f'{NEW_SERVER_URL}/api/v1/user?access_token={NEW_SERVER_API_KEY}'
NEW_SERVER_MIGRATE_API_URL = f'{NEW_SERVER_URL}/api/v1/repos/migrate?access_token={NEW_SERVER_API_KEY}'

OLD_SERVER_API_KEY = 'XXXXXXXXXXXXXXX'
OLD_SERVER_URL = 'https://XXXXXXXXXXX'
OLD_SERVER_REPO_API_URL = f'{OLD_SERVER_URL}/api/v1/user/repos?access_token={OLD_SERVER_API_KEY}'

print('Fetching user id from new server')
user_id = rq.get(NEW_SERVER_USER_API_URL).json()['id']
print(f'User id is {user_id}')

print('Getting list of repos from old server')
old_repos = rq.get(OLD_SERVER_REPO_API_URL).json()

for repo in old_repos:
    print(f'Processing: {repo["name"]}')
    j = {
        'clone_addr': repo['clone_url']
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
