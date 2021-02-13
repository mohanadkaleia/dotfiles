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
    delete(src)
    link(dest, src)

def backup(file):
    
    if not file:
        raise ErrFileNotFound

    shutil.copyfile(file, file + '.backup')

def delete(file):
    if not file:
        raise ErrFileNotFound

    os.remove(file)

def install_apps():
    """
    TODO: 
    1. Check what operating system it is
    2. Install the following packages:
    * fortune, cowsay, zsh, oh-my-zsh, git, homebrew, 
    """
    
    pass



def main():
    print("Bootstraping your dotfiles")
    for file in FILES_TO_TRACK:
        
        if not file.startswith('.'):
            raise ErrNoDotFileFound

        print(f"### {file} ###")
        backup(HOME_DIR + '/' + file)
        copylink(HOME_DIR + '/' + file, DIR_PATH + '/' + file)

    
if __name__ == '__main__':
    main()



