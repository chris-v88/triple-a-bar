export const responseSuccess = (data: unknown, message = 'Success', code = 200) => {
  return {
    status: 'success',
    statusCode: code,
    message,
    data,
  };
};

export const responseError = (
  error: unknown,
  message = 'Internal Server Error',
  code = 500,
  stack: string | null = null,
) => {
  return {
    status: 'error',
    statusCode: code,
    message,
    error: error instanceof Error ? error.message : error,
    stack,
  };
};
