import { apiClient } from '../../../shared/api/apiAxios.js';

/** POST /api/auth/login */
export async function loginRequest(email, password) {
  const { data } = await apiClient.post('/auth/login', { email, password });
  return data;
}
