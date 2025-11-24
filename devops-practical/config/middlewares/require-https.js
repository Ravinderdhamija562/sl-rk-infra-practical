// Force https

// Taken from this answer on S.O
// https://stackoverflow.com/a/31144924

module.exports = function requireHTTPS(req, res, next) {
  // Skip HTTPS redirect if DISABLE_HTTPS_REDIRECT is set (useful for Kubernetes internal services)
  if (process.env.DISABLE_HTTPS_REDIRECT === 'true') {
    return next();
  }
  
  // The 'x-forwarded-proto' check is for Heroku and Kubernetes Ingress
  if (
    !req.secure &&
    req.get('x-forwarded-proto') !== 'https' &&
    process.env.NODE_ENV !== 'development' &&
    process.env.NODE_ENV !== 'test'
  ) {
    return res.redirect('https://' + req.get('host') + req.url);
  }
  next();
};
