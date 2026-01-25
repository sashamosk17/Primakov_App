export const endpoints = {
  auth: {
    login: "/auth/login",
    register: "/auth/register"
  },
  schedule: {
    byGroup: (groupId: string) => `/schedule/${groupId}`,
    byDate: (groupId: string, date: string) => `/schedule/${groupId}/${date}`
  },
  deadlines: "/deadlines",
  ratings: "/ratings"
};
