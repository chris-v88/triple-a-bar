export type TabItem = {
  id: string;
  label: string;
};

export type TabSectionProps = {
  tabs: TabItem[];
  currentTab: string;
  setCurrentTab: (id: string) => void;
};

const TabSection = (props: TabSectionProps) => {
  const { tabs, currentTab, setCurrentTab } = props;

  return (
    <div className="flex space-x-2 mb-4">
      {tabs.map((t) => (
        <button
          key={t.id}
          onClick={() => setCurrentTab(t.id)}
          className={`px-4 py-2 rounded-t-md font-semibold transition-colors
        ${
          currentTab === t.id
            ? 'bg-accent text-white shadow'
            : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
        }`}
          type="button"
        >
          {t.label}
        </button>
      ))}
    </div>
  );
};

export default TabSection;
