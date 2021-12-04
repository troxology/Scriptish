const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({
//    headless: false,
//    executablePath: '/snap/bin/chromium'
    args: [
      '--ignore-certificate-errors'
    ]
  });
  const page = await browser.newPage();
  const address = process.argv[2]
  console.log('Opening page ' + address);
  await page.goto(address);
  const title = await page.title();
  console.log('Saving \'' + title + '\' to pdf.');
  await page.pdf({ path: title + '.pdf', format: 'a4' });
  console.log('Shutting down puppeteer browser.');
  await browser.close();
  console.log('Done.');
})();
