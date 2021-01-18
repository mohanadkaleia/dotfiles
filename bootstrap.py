import os
import shutil


class ErrFileNotFound(Exception):
    pass

class ErrNoFilesToTrack(Exception):
    pass

class ErrNoDotFileFound(Exception):
    pass

FILES_TO_TRACK = ['.zshrc', '.gitconfig']
DIR_PATH = os.path.dirname(os.path.realpath(__file__))
HOME_DIR = os.path.expanduser('~')

def copy(src, dest):
    if not src: 
        raise ErrFileNotFound

    if not dest:
        raise ErrFileNotFound

    shutil.copyfile(src, dest)


def link(src, dest):
    if not src: 
        raise ErrFileNotFound

    if not dest:
        raise ErrFileNotFound

    os.symlink(src, dest)

def copylink(src, dest):
    copy(src, dest)
    link(dest, src)


def main():
    for file in FILES_TO_TRACK:
        
        if not file.startswith('.'):
            raise ErrNoDotFileFound

        print(file)
        copylink(HOME_DIR + '/' + file, DIR_PATH + '/' + file)

    
if __name__ == '__main__':
    main()



