document.addEventListener('DOMContentLoaded', () => {
    const header = document.querySelector('header');
    let lastScrollTop = 0;

    window.addEventListener('scroll', () => {
        let scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        if (scrollTop > lastScrollTop) {
            header.style.top = '0';
        } else {
            header.style.top = '-100px';
        }
        lastScrollTop = scrollTop;
    });
});