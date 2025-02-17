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

document.addEventListener('DOMContentLoaded', function () {
    fetch('/program')  // Hämta sidan igen för att ladda rätt innehåll
      .then(response => response.text())
      .then(html => {
          document.body.innerHTML = html;
      });
});