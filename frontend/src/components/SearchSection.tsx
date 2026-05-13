import SearchBar from './SearchBar';
import TabSection from './TabSection';

type Props = {
  query: string;
  onQueryChange: (value: string) => void;
  loading: boolean;
  currentTab: string;
  onTabChange: (id: string) => void;
};

const TABS = [
  { id: 'drink', label: 'Drink' },
  { id: 'bottle', label: 'Bottles' },
];

const SearchSection = ({ query, onQueryChange, loading, currentTab, onTabChange }: Props) => {
  return (
    <div className="mx-auto mt-6 mb-8 w-full max-w-xl border border-gray-300 rounded-2xl shadow-md px-6 py-4 flex flex-col items-center">
      <TabSection tabs={TABS} currentTab={currentTab} setCurrentTab={onTabChange} />
      <div className="w-full max-w-md mt-2">
        <SearchBar value={query} onChange={onQueryChange} loading={loading} />
      </div>
    </div>
  );
};

export default SearchSection;
